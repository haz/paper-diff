#!/bin/bash

LATEXDIFF=latexdiff-svn
MAINFILE=main.tex

usage() {
    echo
    echo "Usage: $0 directory/path <old revision>"
    echo
    exit 1
}

if [ $# -ne  2 ]
then
    usage
fi

cd $1

REV=$2

echo

for f in *.tex
do
    if [ "$f" != "$MAINFILE" ]
    then
        echo "Working on $f..."
        latexdiff-svn -r $REV $f > /dev/null 2>&1
        if [ -f ${f%%.*}-diff$REV.tex ]
        then
            mv $f $f.orig
            mv ${f%%.*}-diff$REV.tex $f
        fi
    fi
done

echo
echo "Adding the preamble to $MAINFILE..."
echo "" > /tmp/newfile
echo "%DIF PREAMBLE EXTENSION ADDED BY LATEXDIFF" >> /tmp/newfile
echo "%DIF UNDERLINE PREAMBLE %DIF PREAMBLE" >> /tmp/newfile
echo "\RequirePackage[normalem]{ulem} %DIF PREAMBLE" >> /tmp/newfile
echo "\RequirePackage{color}\definecolor{RED}{rgb}{1,0,0}\definecolor{BLUE}{rgb}{0,0,1} %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFadd}[1]{{\protect\color{blue}\uwave{#1}}} %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFdel}[1]{{\protect\color{red}\sout{#1}}} %DIF PREAMBLE" >> /tmp/newfile
echo "%DIF SAFE PREAMBLE %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFaddbegin}{} %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFaddend}{} %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFdelbegin}{} %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFdelend}{} %DIF PREAMBLE" >> /tmp/newfile
echo "%DIF FLOATSAFE PREAMBLE %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFaddFL}[1]{\DIFadd{#1}} %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFdelFL}[1]{\DIFdel{#1}} %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFaddbeginFL}{} %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFaddendFL}{} %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFdelbeginFL}{} %DIF PREAMBLE" >> /tmp/newfile
echo "\providecommand{\DIFdelendFL}{} %DIF PREAMBLE" >> /tmp/newfile
echo "%DIF END PREAMBLE EXTENSION ADDED BY LATEXDIFF" >> /tmp/newfile
echo "" >> /tmp/newfile
cat $MAINFILE >> /tmp/newfile
mv $MAINFILE $MAINFILE.orig
cp /tmp/newfile $MAINFILE

echo
echo "Cleaning up..."
rm *-oldtmp-*

echo
echo "Done!"
echo

