extends Control
## サンプルメイン画面。
## 「進む」ボタンでセリフが進み、途中1回だけキャラ（四角）が小刻みに揺れる。
## ダミー素材だけで組んであるので、本番素材が来たら差し替えるだけでよい。

const LINES: Array[String] = [
	"Webビルドのサンプルだよ。ボタンで進めてね。",
	"今、小刻みに揺れる演出がかかってる。",
	"よかった。ブラウザで動いてるね。",
	"おわり。最後まで進めたら成功だよ。",
]

var _index := 0

@onready var _dialogue_label: Label = $DialoguePanel/DialogueLabel
@onready var _chara: ColorRect = $Chara


func _ready() -> void:
	_show_line()


func _show_line() -> void:
	_dialogue_label.text = LINES[_index]


func _on_next_button_pressed() -> void:
	if _index == 0:
		_shake_chara()
	_index = mini(_index + 1, LINES.size() - 1)
	_show_line()


## 小刻みな揺れ（Tween のサンプル）
func _shake_chara() -> void:
	var base_x := _chara.position.x
	var tween := create_tween()
	for offset in [10.0, -10.0, 6.0, -6.0, 0.0]:
		tween.tween_property(_chara, "position:x", base_x + offset, 0.05)
