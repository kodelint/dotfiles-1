function vid2Gif {
	if [[ $# != 3 ]]; then
		print "too many or too less arguments"
		return
	fi
	ffmpeg -y -i $1.mov -vf fps=10,scale=${2}:${3}:flags=lanczos,palettegen palette_$1.png
	ffmpeg -i $1.mov -i palette_$1.png -filter_complex "fps=10,scale=${2}:${3}:flags=lanczos[x];[x][1:v]paletteuse" -f gif - | gifsicle --optimize=3 > $1.gif
}
