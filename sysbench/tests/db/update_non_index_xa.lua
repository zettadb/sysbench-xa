pathtest = string.match(test, "(.*/)") or ""

dofile(pathtest .. "common.lua")

function thread_init(thread_id)
   set_vars()
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
   local table_name
   local c_val
   local query
   local start_txn_stmt
   local end_txn_stmt
   local xatxnid

   use_xa = (sb_rand(1,100) <= tonumber(oltp_use_xa_pct))
   xatxnid = 'xa_' .. thread_id

   table_name = "sbtest".. sb_rand_uniform(1, oltp_tables_count)
   c_val = sb_rand_str("###########-###########-###########-###########-###########-###########-###########-###########-###########-###########")
   query = "UPDATE " .. table_name .. " SET c='" .. c_val .. "' WHERE id=" .. sb_rand(1, oltp_table_size)
   if (use_xa) then
       db_query("XA START '" .. xatxnid .. "'")
   end

   rs = db_query(query)
   if (use_xa) then
      if (sb_rand(1,100) > tonumber(oltp_use_xa_2pc_pct)) then
          end_xa(xatxnid, 1)
      else
          end_xa(xatxnid, 2)
      end
  end
end
