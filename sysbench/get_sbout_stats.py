import argparse
import math
import json
import time
import re
import pyecharts.options as opts
from pyecharts.charts import Line

def draw_charts(product_name, case_name, total_secs, qps, latency):
	
	secs = range(0, int(total_secs), int(total_secs/100))
	secs.append(int(total_secs))

	c = (
		Line(init_opts=opts.InitOpts(width="1600px", height="800px"))
		.add_xaxis(xaxis_data=secs)
		.add_yaxis(
			series_name="QPS",
			y_axis=qps,
			markpoint_opts=opts.MarkPointOpts(
				data=[
					opts.MarkPointItem(type_="max", name="Max Value"),
					opts.MarkPointItem(type_="min", name="Min Value"),
				]
			),
			markline_opts=opts.MarkLineOpts(
				data=[opts.MarkLineItem(type_="average", name="Average QPS")]
			),
		)
		.add_yaxis(
			series_name="Latency",
			y_axis=latency,
			markline_opts=opts.MarkLineOpts(
				data=[
					opts.MarkLineItem(type_="average", name="Average Latency")
				]
			),
		)
		.set_global_opts(
			title_opts=opts.TitleOpts(title="QPS", subtitle="DML only"),
			tooltip_opts=opts.TooltipOpts(trigger="axis"),
			toolbox_opts=opts.ToolboxOpts(is_show=True),
			xaxis_opts=opts.AxisOpts(type_="category", boundary_gap=False),
		)
		.render("sysbench-" + product_name + '-' + case_name + ".html")
	)

def compute_stddev(vals):
	cnt = len(vals)
	devi = 0.0
	total = 0.0
	avg = total/cnt

	for i in vals:
		total = total + float(i)

	for i in vals:
		diff = float(i) - avg
		devi = devi + diff*diff
	return math.sqrt(devi/cnt)


def compute_stddev(vals, total):
	cnt = len(vals)
	avg = total/(cnt*1.0)
	devi = 0
	for i in vals:
		diff = float(i) - avg
		devi = devi + diff*diff

	return math.sqrt(devi/cnt)

# get_sbout_stats.py --filepath= --product_name= --total_seconds=300 --sample_pts=30
if __name__ == '__main__':

	parser = argparse.ArgumentParser(description='get stat data from sysbench output')
	parser.add_argument('--filepath', help="sysbench result file path")
	parser.add_argument('--product_name', help="DBMS product tested")
	parser.add_argument('--total_seconds', help="NO. of seconds test ran")
	parser.add_argument('--sample_pts', help="NO. of metric points to sample")
	args = parser.parse_args()
	product_name = args.product_name
	total_secs = int(args.total_seconds)

	f = open(args.filepath, 'r')
	case_name = ''
	num_threads = ''
	qps_list = []
	latency_list = []
	started = False

	secs = range(0, int(total_secs), int(total_secs/int(args.sample_pts)))
	lp = Line(init_opts=opts.InitOpts(width="1600px", height="800px"))
	lp_latency = Line(init_opts=opts.InitOpts(width="1600px", height="800px"))

	lp.add_xaxis(xaxis_data=secs)
	lp_latency.add_xaxis(xaxis_data=secs)

	total_qps = 0
	total_latency = 0

	try:
		for line in f:
			if line[0] == '#':
				continue

			stats = re.findall('reads: (\d+\.\d+), writes: (\d+\.\d+), response time: (\d+\.\d+)',line)
			if len(stats) > 0:
				if not started:
					print('QPS,\t\tLatency')
					started = True
					latency_list.clear()
					qps_list.clear()
					total_qps = 0
					total_latency = 0

				qps = float(stats[0][0]) + float(stats[0][1])
				ltc = stats[0][2]
				qps_list.append(qps)
				latency_list.append(ltc)
				total_qps = total_qps + float(qps)
				total_latency = total_latency + float(ltc)
				print(qps , ',\t', ltc)
			else:
				if started:
					lp.add_yaxis(
						series_name= case_name + '-' + num_threads + "-QPS",
						y_axis=qps_list,
						symbol='dot',
						is_symbol_show=True,
						label_opts=opts.LabelOpts(is_show=False),
						markpoint_opts=opts.MarkPointOpts(
							data=[
								opts.MarkPointItem(type_="max", name="Max Value"),
								opts.MarkPointItem(type_="min", name="Min Value"),
							]
						),
						markline_opts=opts.MarkLineOpts(
							data=[opts.MarkLineItem(type_="average", name="Average QPS")]
						),
					)

					lp_latency.add_yaxis(
						series_name= case_name + '-' + num_threads + "-Latency",
						y_axis=latency_list,
						symbol='dot',
						is_symbol_show=True,
						label_opts=opts.LabelOpts(is_show=False),
						markline_opts=opts.MarkLineOpts(
							data=[
								opts.MarkLineItem(type_="average", name="Average Latency")
							]
						),
					)
					started = False
					qps_std_dev = compute_stddev(qps_list, total_qps)
					latency_std_dev = compute_stddev(latency_list, total_latency)
					print('\n', case_name[:-1], " QPS stddev: ", qps_std_dev, ", latency stddev: ", latency_std_dev)
				else:
					xx = line.find(".lua")
					if xx >= 0:
						case_name = line
					else:
						num_thds = line.find("Number of threads: ")
						if num_thds >= 0:
							num_threads = str(int(line[num_thds + 18:]))
				print(line)
	finally:
		f.close()

	lp.set_global_opts(
			title_opts=opts.TitleOpts(title="QPS", subtitle="DML only"),
			tooltip_opts=opts.TooltipOpts(trigger="axis"),
			toolbox_opts=opts.ToolboxOpts(is_show=True),
			xaxis_opts=opts.AxisOpts(type_="category", boundary_gap=False),
		)
	lp.render("sysbench-" + product_name + "-QPS.html")

	lp_latency.set_global_opts(
			title_opts=opts.TitleOpts(title="Latency", subtitle="DML only"),
			tooltip_opts=opts.TooltipOpts(trigger="axis"),
			toolbox_opts=opts.ToolboxOpts(is_show=True),
			xaxis_opts=opts.AxisOpts(type_="category", boundary_gap=False),
		)
	lp_latency.render("sysbench-" + product_name + "-latency.html")
