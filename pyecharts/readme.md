# pyecharts转成图片
```python
from pyecharts.render import make_snapshot
from snapshot_phantomjs import snapshot
make_snapshot(snapshot, chart.render(chartpath), chartpic, is_remove_html=True)
```

# myfonts解决phantomjs转成图片中文字体乱码的问题