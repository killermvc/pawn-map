#define RUN_TESTS
#define YSI_NO_VERSION_CHECK
#pragma dynamic 65536
#include <a_samp>
#include "map.inc"
#include <YSI_Core\y_testing>

Test:New()
{
	const
		size1 = 12,
		size2 = 16;
	new Map:map<size1, size2>;
	#pragma unused map
	ASSERT_EQ(sizeof map, size1);
	ASSERT_EQ(sizeof map[], MAX_COLLISIONS);
	ASSERT_EQ(sizeof map[][], size2 + 2);
}

Test:Add()
{
	const size = 12;
	new Map:map<size, 16>;
	Map_Add(map, "key", 20);
	new idx = fnv1("key") % size;
	ASSERT_EQ(map[idx][0][0], 20);
	ASSERT_SAME(_:map[idx][0][1], "key");
}

Test:Get()
{
	new Map:map<12, 16>;
	Map_Add(map, "key", 20);
	ASSERT_EQ(20, Map_GetValue(map, "key"));
}

Test:ContainsKey()
{
	new Map:map<12, 16>;
	Map_Add(map, "key", 20);
	ASSERT(Map_ContainsKey(map, "key"));
}

Test:Remove1()
{
	new Map:map<12, 16>;
	Map_Add(map, "key", 20);
	Map_Remove(map, "key");
	ASSERT_FALSE(Map_ContainsKey(map, "key"));
}

Test:Remove2()
{
	new Map:map<12, 16>;
	Map_Add(map, "key", 20);
	Map_Add(map, "key1", 20);
	Map_Add(map, "key2", 20);
	Map_Remove(map, "key1");
	ASSERT(Map_ContainsKey(map, "key"));
	ASSERT_FALSE(Map_ContainsKey(map, "key1"));
	ASSERT(Map_ContainsKey(map, "key2"));
}

Test:Add100()
{
	new Map:map<100, 16>, key[7];
	for(new i = 0; i < 100; ++i)
	{
		format(key, sizeof key, "key%d", i);
		Map_Add(map, key, i+1);
	}

	for(new i = 0; i < 100; ++i)
	{
		format(key, sizeof key, "key%d", i);
		ASSERT(Map_ContainsKey(map, key));
		ASSERT_EQ(i+1, Map_GetValue(map, key));
	}
}

Test:Remove50()
{
	new Map:map<100, 16>, key[7];
	for(new i = 0; i < 100; ++i)
	{
		format(key, sizeof key, "key%d", i);
		Map_Add(map, key, i+1);
	}

	for(new i = 0; i < 100; i += 2)
	{
		printf("i");
		format(key, sizeof key, "key%d", i);
		Map_Remove(map, key);
	}

	for(new i = 0; i < 100; ++i)
	{
		format(key, sizeof key, "key%d", i);
		if(i % 2 == 0)
		{
			ASSERT_FALSE(Map_ContainsKey(map, key));
		}
		else
		{
			ASSERT(Map_ContainsKey(map, key));
			ASSERT_EQ(i+1, Map_GetValue(map, key));
		}
	}
}