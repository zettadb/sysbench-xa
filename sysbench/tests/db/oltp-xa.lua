pathtest = string.match(test, "(.*/)") or ""

dofile(pathtest .. "common.lua")

function thread_init(thread_id)
   set_vars()

   if (((db_driver == "mysql") or (db_driver == "attachsql")) and mysql_table_engine == "myisam") then
      begin_query = "LOCK TABLES sbtest WRITE"
      commit_query = "UNLOCK TABLES"
   else
      begin_query = "BEGIN"
      commit_query = "COMMIT"
   end

  -- xa_txnids[thread_id] = 0
end

function end_xa(xatxnid, nphases)
   if (nphases == 2) then
       db_query("XA END '" .. xatxnid .. "'");
       db_query("XA PREPARE '" .. xatxnid .. "'")
       db_query("XA COMMIT '" .. xatxnid .. "'")
   else
       
       db_query("XA END '" .. xatxnid .. "'");
       db_query("XA COMMIT '" .. xatxnid .. "' ONE PHASE")
   end
end

function event(thread_id)
   local rs
   local i
   local table_name
   local range_start
   local c_val
   local pad_val
   local query
   local start_txn_stmt
   local end_txn_stmt
   local xatxnid

   start_txn_stmt = ""
   use_xa = (sb_rand(1,100) <= tonumber(oltp_use_xa_pct))
   --xa_txnids[thread_id] =  xa_txnids[thread_id] + 1
   xatxnid = 'xa_' .. thread_id
   if (use_xa) then
       start_txn_stmt = "XA START '" .. xatxnid .. "'"
       end_txn_stmt2 = "XA END '" .. xatxnid .. "'; XA PREPARE '" .. xatxnid .. "'; XA COMMIT '" .. xatxnid .. "'"
       end_txn_stmt1 = "XA END '" .. xatxnid .. "'; XA COMMIT '" .. xatxnid .. "' ONE PHASE"
   else
       start_txn_stmt = begin_query
       commit_query = "COMMIT"
   end

   table_name = "sbtest".. sb_rand_uniform(1, oltp_tables_count)
   if not oltp_skip_trx then
      db_query(start_txn_stmt)
      --print("thread " .. thread_id .. " : " .. start_txn_stmt)
      -- print "thread " .. thread_id .. " : " .. start_txn_stmt
   end
   
   if not oltp_write_only then

   for i=1, oltp_point_selects do
      rs = db_query("SELECT c FROM ".. table_name .." WHERE id=" .. sb_rand(1, oltp_table_size))
   end

   for i=1, oltp_simple_ranges do
      range_start = sb_rand(1, oltp_table_size)
      rs = db_query("SELECT c FROM ".. table_name .." WHERE id BETWEEN " .. range_start .. " AND " .. range_start .. "+" .. oltp_range_size - 1)
   end
  
   for i=1, oltp_sum_ranges do
      range_start = sb_rand(1, oltp_table_size)
      rs = db_query("SELECT SUM(K) FROM ".. table_name .." WHERE id BETWEEN " .. range_start .. " AND " .. range_start .. "+" .. oltp_range_size - 1)
   end
   
   for i=1, oltp_order_ranges do
      range_start = sb_rand(1, oltp_table_size)
      rs = db_query("SELECT c FROM ".. table_name .." WHERE id BETWEEN " .. range_start .. " AND " .. range_start .. "+" .. oltp_range_size - 1 .. " ORDER BY c")
   end

   for i=1, oltp_distinct_ranges do
      range_start = sb_rand(1, oltp_table_size)
      rs = db_query("SELECT DISTINCT c FROM ".. table_name .." WHERE id BETWEEN " .. range_start .. " AND " .. range_start .. "+" .. oltp_range_size - 1 .. " ORDER BY c")
   end

   end -- oltp_write_only

   if not oltp_read_only then

   for i=1, oltp_index_updates do
      rs = db_query("UPDATE " .. table_name .. " SET k=k+1 WHERE id=" .. sb_rand(1, oltp_table_size))
   end

   for i=1, oltp_non_index_updates do
      c_val = sb_rand_str("###########-###########-###########-###########-###########-###########-###########-###########-###########-###########")
      query = "UPDATE " .. table_name .. " SET c='" .. c_val .. "' WHERE id=" .. sb_rand(1, oltp_table_size)
      rs = db_query(query)
      if rs then
        print(query)
      end
   end

   i = sb_rand(1, oltp_table_size)

   rs = db_query("DELETE FROM " .. table_name .. " WHERE id=" .. i)
   
   c_val = sb_rand_str([[
###########-###########-###########-###########-###########-###########-###########-###########-###########-###########]])
   pad_val = sb_rand_str([[
###########-###########-###########-###########-###########]])

   rs = db_query("INSERT INTO " .. table_name ..  " (id, k, c, pad) VALUES " .. string.format("(%d, %d, '%s', '%s')",i, sb_rand(1, oltp_table_size) , c_val, pad_val))

   end -- oltp_read_only

   -- 20% txns do 1pc, 80% do 2pc. sb_rand(a,b) is produces rand numbers in [a,b]
   if not oltp_skip_trx then
      if (not use_xa) then
          db_query(commit_query)
          --print ("thread ".. thread_id .. " : " .. commit_query)
      else
          if (sb_rand(1,100) > tonumber(oltp_use_xa_2pc_pct)) then
              --db_query(end_txn_stmt1)
              end_xa(xatxnid, 1)
              -- print ("thread ".. thread_id .. " : " .. end_txn_stmt1)
          else
              --db_query(end_txn_stmt2)
              end_xa(xatxnid, 2)
              -- print ("thread ".. thread_id .. " : " .. end_txn_stmt2)
          end
      end
   end

end

