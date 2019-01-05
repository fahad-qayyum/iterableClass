note
	description: "Summary description for {RECORD_ITERATION_CURSOR}."
	author: "Fahad Qayyum"
	date: "$Date$"
	revision: "$Revision$"

class
	RECORD_ITERATION_CURSOR [ V1, V2, K ]

inherit
	ITERATION_CURSOR [ RECORD [V1, V2, K] ]

create
	make

feature{NONE} --Atributes
	value_1_arr : ARRAY[V1]
	value_2_ll : LINKED_LIST[V2]
	key_ll : LINKED_LIST[K]
	cur_pos : INTEGER

feature
	make(v1 : ARRAY[V1]; v2 : LINKED_LIST[V2]; k : LINKED_LIST[K])
		do
			value_1_arr := v1
			value_2_ll := v2
			key_ll := k
			cur_pos := v1.lower
		end

feature -- Cursor Operations
	item : RECORD[V1, V2, K]
		do
			create result.make(value_1_arr[cur_pos], value_2_ll[cur_pos], key_ll[cur_pos])  --  or the following
--result := create {RECORD[V1, V2, K]}.make (value_1_arr[cur_pos], value_2_ll[cur_pos], key_ll[cur_pos])
		end
	after : BOOLEAN
		do
			Result := cur_pos > value_1_arr.upper
		end
	forth
		do
			cur_pos := cur_pos + 1
		end
end
