defmodule Helpers do

	def get_Assings(file_name) do
		cap1 = ~r/([\w]*(?<assign>@[\w]+))/
		cap2 = ~r/([\w]*(?<assign>assigns\[:\w+\]))/

		case File.read(file_name) do
		{:ok, content} ->  	IO.inspect "********  Written by Attaf Habib  ********"
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
end