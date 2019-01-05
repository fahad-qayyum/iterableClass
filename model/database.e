note
	description: "A DATABASE ADT mapping from keys to two kinds of values"
	author: "Jackie Wang and Fahad Qayyum"
	date: "$Date$"
	revision: "$Revision$"

class
	DATABASE[V1, V2, K]

inherit
	ITERABLE [ TUPLE [ K , V1 , V2 ] ]

create
	make

feature {EXAMPLE_DATABASE_TESTS} -- Do not modify this export status!
	-- You are required to implement all database features using these three attributes.
	keys: LINKED_LIST[K]
	values_1: ARRAY[V1]
	values_2: LINKED_LIST[V2]

feature -- feature(s) required by ITERABLE
	-- Your Task
	-- See test_iterable_databse and test_iteration_cursor in EXAMPLE_DATABASE_TESTS.
	-- As soon as you make the current class iterable,
	-- define the necessary feature(s) here.
	new_cursor : TUPLE_ITERATION_CURSOR [ K, V1, V2 ]
	do
		create Result.make( keys , values_1 , values_2 )
	end


feature -- alternative iteration cursor
	another_cursor : ITERATION_CURSOR [ RECORD [ V1, V2, K ]]
	do
		create {RECORD_ITERATION_CURSOR [ V1, V2, K ]}Result.make( values_1 , values_2 , keys )

	end
	-- Your Task
	-- See test_another_cursor in EXAMPLE_DATABASE_TESTS.
	-- A feature 'another_cursor' is expected to be defined here.

feature -- Constructor
	make
			-- Initialize an empty database.
		do
			-- Your Task
			create keys.make
			create values_1.make_empty
			create values_2.make
			keys.compare_objects
			values_1.compare_objects
			values_2.compare_objects

		ensure
			empty_database: -- Your Task
				keys.is_empty and values_1.is_empty and values_2.is_empty
			-- Do not modify the following three postconditions.
			object_equality_for_keys:
				keys.object_comparison
			object_equality_for_values_1:
				values_1.object_comparison
			object_equality_for_values_2:
				values_2.object_comparison
		end

feature -- Commands

	add_record (v1: V1; v2: V2; k: K)
			-- Add a new record into current database.
		require
			non_existing_key: -- Your Task
				not exists (k)
		do
			-- Your Task
			values_1.force (v1, (count + 1))
			values_2.extend (v2)
			keys.extend (k)
		ensure
			record_added: -- Your Task
				values_1.has (v1) and values_2.has (v2) and exists(k)
		end

	remove_record (k: K)
			-- Remove a record from current database.s
		require
			existing_key: -- Your Task
				exists (k)
		local
			new_keys_ll : LINKED_LIST[K]
			new_value_2_ll : LINKED_LIST[V2]
			new_value_1_arr : ARRAY[V1]
			num : INTEGER
			num2 : INTEGER

		do
			-- Your Task
			num := 1
			create new_keys_ll.make
			across keys as x loop
				if x.item ~ k then
					num2 := num
				else if x.item /~ k then
					new_keys_ll.extend (x.item)
					num := num + 1
				end
				end
			end
			keys := new_keys_ll
			create new_value_2_ll.make
			across values_2 as x loop
				if x.item /~ values_2.at(num2) then
					new_value_2_ll.extend (x.item)
				end
			end
			values_2 := new_value_2_ll
			create new_value_1_arr.make_empty
			across values_1 as x loop
				if x.item /~ values_1.at (num2) then
					new_value_1_arr.force (x.item, (new_value_1_arr.count + 1) )
				end
			end
			values_1 := new_value_1_arr

		ensure
			database_count_decremented:-- Your Task
				count ~ (old count - 1)
			key_removed: -- Your Task
				not exists(k)
		end

feature -- Queries

	count: INTEGER
			-- Number of records in database.
		do
			-- Your Task
			result := values_1.count
		ensure
			correct_result: -- Your Task
				result = keys.count
		end

	exists (k: K): BOOLEAN
			-- Does key 'k' exist in the database?
		do
			-- Your Task
			across keys as cursor loop
				if cursor.item ~ k then
					Result := TRUE
				end
			end

		ensure
			correct_result: -- Your Task
				Result = exists (k)
		end

	get_keys (v1: V1; v2: V2): ITERABLE[K]
			-- Keys that are associated with values 'v1' and 'v2'.
		local
			ll : LINKED_LIST[K]
			i : INTEGER
		do
			-- Your Task
			create ll.make
			from
				i := values_1.lower
			until
				i > values_1.upper
			loop
				if values_1[i] ~ v1 and values_2[i] ~ v2 then ll.extend (keys.at (i))
				end
				i := i + 1
			end
			result := ll
		ensure
			result_contains_correct_keys_only: -- Your Task
				-- Hint: Each key in Result has its associated values 'v1' and 'v2'.	
				across result as x all
					(values_1.at (keys.index_of (x.item, 1))  ~ v1) and (values_2.at (keys.index_of (x.item, 1)) ~ v2)
				end
			correct_keys_are_in_result: -- Your Task
				-- Hint: Each record with values 'v1' and 'v2' has its key included in Result.
				-- Notice that Result is ITERABLE and does not support the feature 'has',
				-- Use the appropriate across expression instead.
--				across result as k_cursor all
--					if (across current as db_cursor some db_cursor.item[2] ~ v1 and db_cursor.item[3] ~ v2 and k_cursor.item ~ db_cursor.item[1] end) then
--						TRUE
--					else
--						FALSE
--					end

--				end
--		end
				across current as db_cursor all
					if(db_cursor.item[2] ~ v1) and (db_cursor.item[3] ~ v2) and (across result as r_cursor all not exists (r_cursor.item) end) then
						FALSE
					else
						TRUE
					end
				end
end
invariant
	unique_keys: -- Your Task
		-- Hint: No two keys are equal to each other.

			across keys as i all 						-- cursor at the beginning of the array
				across keys as j all 					-- another cursor at the beginning of the array
					if i /~ j and i.item ~ j.item then	-- if cursor not at same position but item match
						FALSE							-- then the contents are same and hence are not unique
					else
						TRUE
					end
				end
			end
	-- Do not modify the following three class invariants.
	implementation_contraint:
		values_1.lower = 1
	consistent_keys_values_counts:
		keys.count = values_1.count
		and
		keys.count = values_2.count
	consistent_imp_adt_counts:
		keys.count = count
end
