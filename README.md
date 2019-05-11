# lua-performance-demo
A demo using WRK and flame graph to locate OpenResty performance issues

# using WRK for benchmark
```bash
wrk -c100 -t10 -d20s http://127.0.0.1:8080
```

# using systemtap and stapxx to get flamegraph
```bash
export PATH=/media/psf/Home/work/stapxx:/media/psf/Home/work/FlameGraph:/media/psf/Home/work/openresty-systemtap-toolkit:$PATH

./samples/lj-lua-stacks.sxx --arg time=5  --skip-badvars -x 4959 > a.bt

stackcollapse-stap.pl a.bt > a.cbt

flamegraph.pl --encoding="ISO-8859-1" \
              --title="Lua-land on-CPU flamegraph" \
              a.cbt > a.svg
```
