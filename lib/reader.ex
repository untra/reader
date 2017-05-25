defmodule Reader do
  @text_file_path "./priv/WarAndPeace.txt"

  @ignore [""] ++ ~W(
    the or to a and or his her their in this that will was of
    with is be him her had have he she it i me you at not on as
    but said for all any from if no an so been are now then esle
    all from were by they who which one what my yours your
  )

  @punctuation ~r/[:.,!?;”\-\(\)\/]/

  @tally :tally

  def concurrent_read() do
    # start a new agent
    {:ok, agent} =  Agent.start_link(fn -> %{} end)
    # register the agent as :tally
    Process.register(agent, @tally)

    Task.async(&read_and_stream_file/0)
  end

  def read_and_stream_file() do
    @text_file_path
    |> File.stream!()
    |> Stream.chunk(500)
    |> Task.async_stream(&(Reader.process_batch(&1)))
    |> Stream.run()
  end

  def process_batch(line_batch) do
    line_batch
    |> Enum.flat_map(&String.split(&1, " "))
    |> Enum.each(&(Reader.process_word(&1)))
  end

  def sanitize_word(word) do
    word
    |> String.trim()
    |> String.replace(@punctuation, "")
    |> String.downcase
  end

  def update_word_count(agent, word) do
    Agent.update(agent, fn words ->
      Map.update(words, word, 1, &(&1 + 1))
    end)
  end

  def process_word(word) do
    cleaned_word = sanitize_word(word)
    unless Enum.member?(@ignore, cleaned_word) do
      update_word_count(@tally, cleaned_word)
    end
  end

end
