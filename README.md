## DistributedAudio

Tool to distribute audio, in a failing manner, via elixir.  Present state can be
run on a single node with:

```
iex -S mix
DistributedAudio.Sender.start_link([])
```

