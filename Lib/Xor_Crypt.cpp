AnsiString xor_crypt (const AnsiString& src)
{
	AnsiString result=src;
	const AnsiString& key="yxavyzazayxa";
	for (unsigned i = 1; i<=src.Length(); )
		for (unsigned j = 1; j<=key.Length() && i<=src.Length(); ++i, ++j)
		{
			result[i]^=key[j];
			if (result[i]=='@' || result[i]=='_' || result[i]=='^') 
				result[i]='G';
		}
	return result;
}