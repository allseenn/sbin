#!/bin/bash
# apt install ghostscript imagemagick
IN=$*
DATE=`date +%Y%m%d`
OPERATION=`zenity --list --title="Работа с ПДФ" --text="Выберите работу" --column="Работа" --column="Описание" --width=470 --height=420 \
RANGE "Извлечение диапазона страниц из ПДФ" \
PAGES "Каждая страница ПДФ в отдельный файл" \
SIZE "Изменение размера мегабайт ПДФ файла" \
PIXEL_SIZE "Изменение размера  ПДФ файла по пикселям" \
BLACK "Черно-белый формат" \
IMAGE "Преобразовать текстовый ПДФ в графический вид" \
WATER "Добавить водяной знак" \
TRANS "Сделать фон прозрачным - на выходе PNG" \
ALLPDF "Конвертировать любой файл(ы) в pdf файлы" \
MERGE "Объединение файлов ПДФ в один" \
ROTAT "Вращение фйала на заданный градус" \
CONVERT "Конвертировать файл в другой формат"`

if [[ $OPERATION = RANGE ]]
then
OUT=`zenity --file-selection --save --title="Название сохранненной части ПДФ файла?"`
ZEN=`zenity --forms --title="Выбор страниц" --text="Выберети диапазон страниц" --separator=" " --add-entry="Начальная страница" --add-entry="Последняя страница"`
FIRST=`echo $ZEN | awk '{print $1}'`
LAST=`echo $ZEN | awk '{print $2}'`
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dFirstPage=$FIRST -dLastPage=$LAST -sOutputFile=$OUT $IN
fi

if [[ $OPERATION = PAGES ]]
then
ZEN=`zenity --file-selection --save --title="Название сохранненной части ПДФ файла?"`
OUT=`echo $ZEN | sed -e 's\.pdf\%d.pdf\g'`
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -sOutputFile=$OUT $IN
fi

if [[ $OPERATION = SIZE ]]
then
OUT=`zenity --file-selection --save --title="Название уменьшенного ПДФ файла?"`
SCALE=`zenity --list --radiolist --title="Размер уменьшенного ПДФ Файла?" --column="Выбор" --column="Степень" FALSE screen TRUE ebook FALSE printer FALSE prepress`
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/$SCALE -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$OUT $IN
fi

if [[ $OPERATION = PIXEL_SIZE ]]
then
OUT=`zenity --file-selection --save --title="Название уменьшенного ПДФ файла?"`
PIXEL=`zenity --forms --title="Выбор разрешения" --text="Выбор качества в пикселях" --add-entry="130"`
convert -density $PIXEL -quality 60 -compress jpeg $IN $OUT
fi

if [[ $OPERATION = BLACK ]]
then
OUT=`zenity --file-selection --save --title="Название черно-белого выходного ПДФ файла?"`
gs -dNOPAUSE -q -sProcessColorModel=DeviceGray -sColorConversionStrategy=Gray -sDEVICE=pdfwrite -sOutputFile=$OUT $IN
fi

if [[ $OPERATION = IMAGE ]]
then
OUT=`zenity --file-selection --save --title="Название преобразованного в картинку ПДФ файла?"`
gs -dBATCH -dNOPAUSE -q -sDEVICE=jpeg -r300 -sOutputFile=/tmp/jpeg\%02d.jpg $IN
convert /tmp/jpeg*.jpg $OUT
rm /tmp/jpeg*.jpg
fi

if [[ $OPERATION = WATER ]]
then
INPUT_PDF=$(zenity --file-selection --title="Select Input PDF File")

# Check if input PDF file was selected
if [ -z "$INPUT_PDF" ]; then
  echo "No input PDF file selected. Exiting."
  exit 1
fi

# Get watermark text from user
WATERMARK=$(zenity --forms --title="Watermark Text" --text="Enter Watermark Text" --add-entry="Name")

# Create temporary watermark PDF
TMP_WATERMARK_PDF="watermark.pdf"
gs -q -sDEVICE=pdfwrite -o "$TMP_WATERMARK_PDF" -g595x842 -c "
  /Helvetica-Bold findfont 36 scalefont setfont
  0.7 setgray
  72 500 moveto 50 rotate
  (${WATERMARK}) show
"

# Add watermark to output PDF using RPDF
R --vanilla << EOF
library(RPDF)

# Get output PDF file path (you might want to change this)
OUTPUT_PDF="watermarked_output.pdf"

# Load input PDF
pdf_obj <- pdf(INPUT_PDF)

# Add watermark page with temporary watermark PDF
pdf_obj$addPage(overlay = pdf(TMP_WATERMARK_PDF))

# Save watermarked PDF
pdf_obj$save(OUTPUT_PDF)

# Close PDF object
close(pdf_obj)

# Delete temporary watermark PDF
unlink(TMP_WATERMARK_PDF)
EOF

fi

if [[ $OPERATION = TRANS ]]
then
OUT=`zenity --file-selection --save --title="Название прозрачного файла PNG?"`
gs -dNOPAUSE -dBATCH -sDEVICE=pngalpha -r300 -sOutputFile=tmp.png $IN
convert -colorspace GRAY tmp.png $OUT.png
rm tmp.png
fi

if [[ $OPERATION = ALLPDF ]]
then
mogrify -quality 300 -format pdf -- $IN
fi

if [[ $OPERATION = MERGE ]]
then
OUT=`zenity --file-selection --save --title="Название объединенного ПДФ файла?"`
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$OUT $IN
fi

if [[ $OPERATION = ROTAT ]]
then
OUT=`zenity --file-selection --save --title="Название измененного файла?"`
GRAD=`zenity --forms --title="Выбор градуса" --text="Градус вращения" --add-entry="90"`
convert --rotate $GRAD $IN $OUT
fi

if [[ $OPERATION = CONVERT ]]
then
OUT=`zenity --file-selection --save --title="Название измененного файла?"`
PROC=`zenity --forms --title="Выбор качества" --text="Процент качества" --add-entry="50"`
convert --quality $PROC $IN $OUT
fi
