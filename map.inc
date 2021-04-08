#define Map:%0<%1,%2,%3>				Map:%0[(%1)][(%2)][(%3) + 2]

const FNV_offset_basis = 2166136261;
const FNV_prime = 16777619;

stock fnv1(const str[], &len = -1) {
    if(len < 0) {
        len = strlen(str);
    }

    new hash = FNV_offset_basis, i;
    while(i != len) {
        hash = hash * FNV_prime;
        hash = hash ^ str[i++];
    }
    return hash;
}

stock Map_Add(Map:map[][][], const key[], value, maxkeys = sizeof map, collisions = sizeof map[], maxKeySize = sizeof map[][])
{
	new index = fnv1(key) % maxkeys;

	new i = 0;
	while(i < collisions && _:map[index][i][1] != '\0' && strcmp(_:map[index][i][1], key))
		i++;

	if(i == collisions)
		return 0;

	if(_:map[index][i][0] == 0)
		strcat(_:map[index][i][1], key, maxKeySize);
	map[index][i][0] = Map:value;
	return 1;
}

stock Map_GetValue(const Map:map[][][], const key[], maxkeys = sizeof map, collisions = sizeof map[])
{
	new index = fnv1(key) % maxkeys;
	for(new i = 0; i < collisions && _:map[index][i][1] != '\0'; ++i)
	{
		if(!strcmp(_:map[index][i][1], key))
			return _:map[index][i][0];
	}
	return -1;
}

stock bool:Map_ContainsKey(const Map:map[][][], const key[], maxkeys = sizeof map, collisions = sizeof map[])
{
	new index = fnv1(key) % maxkeys;
	for(new i = 0; i < collisions && _:map[index][i][1] != '\0'; ++i)
	{
		if(!strcmp(_:map[index][i][1], key))
			return true;
	}
	return false;
}

stock Map_Remove(Map:map[][][], const key[], maxkeys = sizeof map, collisions = sizeof map[], size3 = sizeof(map[][]))
{
	new index = fnv1(key) % maxkeys, i = 0, bool:found = false;
	for(; i < collisions && !found && _:map[index][i][1] != '\0'; ++i)
	{
		if(!strcmp(_:map[index][i][1], key))
			found = true;
	}
	if(!found)
		return 0;

	--i;
	for(; i < collisions - 1 && _:map[index][i][1] != '\0'; ++i)
	{
		memcpy(_:map[index][i], _:map[index][i+1], 0, size3 * 4,  size3);
	}
	if(i == collisions - 1)
		memset(_:map[index][collisions-1], 0, size3);
	return 1;
}