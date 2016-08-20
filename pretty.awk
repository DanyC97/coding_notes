	# gawk profile, created Fri Aug 19 23:12:41 2016

	# BEGIN block(s)

	BEGIN {
		printf "---|Header|--\n"
	}

	# Rule(s)

	{
		print $0
	}

	# END block(s)

	END {
		printf "---|Footer|---\n"
	}

