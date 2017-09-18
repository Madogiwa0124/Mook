// 定数管理
var TEEMA = ["lightcoral", "lightsalmon", "lightgreen", "lightblue"]
var MAX_DATA_CNT = 8

// ページ読み込み後の処理
window.onload = function () {
  tags = JSON.parse(document.getElementById('tag_info').dataset.json);
  createTagPieGraf(tags)
}  

function createTagPieGraf(data) {
  // データの整形
  tags = tags.sort(function (a, b) {
    if (a.value < b.value) return  1;
    if (a.value > b.value) return -1;
    return 0;
  }).slice(0, MAX_DATA_CNT);
  // 色の設定
  for (var i = 0; i < tags.length; i++) {
    tags[i].color = TEEMA[i % 4];
  }
  // 生成オプションの設定
  var options = {
    animation : true,
    animationSteps: 60,
    animationEasing: "easeInOutCubic",
    responsive:true
  };
  // 円グラフの描画
  var myChart = new Chart(document.getElementById("mycanvas").getContext("2d")).Pie(tags,options);  
}