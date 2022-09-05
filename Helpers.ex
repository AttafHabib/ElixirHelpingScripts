defmodule Helpers do

	def get_assings(path_to_file) do
		cap1 = ~r/([\w]*(?<assign>@[\w]+))/
		cap2 = ~r/([\w]*(?<assign>assigns\[:\w+\]))/

		case File.read(path_to_file) do
		{:ok, content} ->  	
							content = content
							|> String.split("\n", trim: true)
							|>Enum.reduce([], &capture_assigns(&1,&2))
							|>List.flatten
							|>Enum.uniq
							|>IO.inspect(limit: :infinity)

		{:error, reason} -> IO.puts "Error in opening File #{reason}"

		_ -> IO.puts "Error in opening File, Invalid match."
		end
	end

	defp capture_assigns(x, acc) do
		cap1 = ~r/([\w]*(?<assign>@[\w]+))/
		cap2 = ~r/([\w]*(?<assign>assigns\[:\w+\]))/

		capture = (Regex.named_captures(cap1, x) || Regex.named_captures(cap2, x))["assign"]
		key = capture && String.trim_leading capture, "@"
		capture = (capture && [{String.to_atom(key), capture}])|| []

		acc ++ [capture]

	end

	defp capture_comments(line, acc) do
		line_no = if(length(acc) == 0)do
			1
		else
			[head | _] = acc
			head
		end

		if(Regex.match? ~r/<%#/, line) do
			{[line_no], [line_no + 1 | acc]}
		else
			{[], [line_no + 1 | acc]}
		end
	end

	def get_comment_lines(path_to_file) do
		case File.read(path_to_file) do
			{:ok, content} -> IO.inspect "********  Written by Attaf Habib  ********"
												{content, _} = content
																			 |> String.split("\n")
																			 |> Enum.flat_map_reduce([], &capture_comments(&1, &2))
												IO.inspect "Following line numbers have <%# comment in them"
												IO.inspect content, limit: :infinity
			{:error, reason} -> IO.puts "Error in opening File #{reason}"
			_ -> IO.puts "Error in opening File, Invalid match."
		end
	end
end
