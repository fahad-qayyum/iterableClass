note
	description: "Summary description for {TUPLE_ITERATION_CURSOR}."
	author: "Fahad Qayyum"
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_ITERATION_CURSOR [ K, V1, V2 ]

inherit
	ITERATION_CURSOR [ TUPLE [ K, V1, V2 ]]

create
	make

feature{NONE} --Atributes
	value_1_arr : ARRAY[V1]
	value_2_ll : LINKED_LIST[V2]
	key_ll : LINKED_LIST[K]
	cur_pos : INTEGER

feature
	make( k : LINKED_LIST[K]; v1 : ARRAY[V1]; v2 : LINKED_LIST[V2])
		do
			key_ll := k
			value_1_arr := v1
			value_2_ll := v2
			cur_pos := value_1_arr.lower
		end

feature -- Cursor Operations
	item : TUPLE[K, V1, V2]
		local
			value_1 : V1
			value_2 : V2
			key : K
		do
			value_1 := value_1_arr[cur_pos]
			value_2 := value_2_ll.at (cur_pos)
			key := key_ll.at (cur_pos)
			create result
			Result :=  [ key , value_1 , value_2 ]
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
