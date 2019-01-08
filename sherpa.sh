#!/bin/sh

WORKSPACE=${PWD}
SOURCE=$WORKSPACE/src
TARGET=$WORKSPACE/target

CSS=$SOURCE/css
FONTS=$SOURCE/fonts
PAGES=$SOURCE/pages
IMAGES=$SOURCE/images
PDF=$SOURCE/pdf
EPUB=$SOURCE/epub
JS=$SOURCE/js
SASS=$SOURCE/sass
TEMPLATES=$SOURCE/templates
VENDOR=$SOURCE/vendor
ROOT=$SOURCE/root

ASSETS=$TARGET/assets

clean () {
    echo 'limpiando'
	rm -rf $TARGET/*
}

prepare () {
    echo preparando estructura
	mkdir -p $ASSETS
    mkdir -p $ASSETS/js
    mkdir -p $ASSETS/css
    mkdir -p $ASSETS/pdf
    mkdir -p $ASSETS/epub
	cp -R $IMAGES $ASSETS
	cp -R $FONTS $ASSETS
    cp -R $PDF $ASSETS
    cp -R $EPUB $ASSETS
    cp -R $VENDOR $ASSETS
    copy_root_files
}

sass_compile () {
    echo 'compilando sass'
	sass $SASS/clean-blog.scss $ASSETS/css/clean-blog.css
}

sass_watch () {
    sass --watch $SASS/clean-blog.scss $ASSETS/css/clean-blog.css
}

sass_compress () {
    echo 'comprimiendo sass'
	sass $SASS/clean-blog.scss -s compressed $ASSETS/css/clean-blog.css
}

html_all () {
    echo 'copiando html'
    cp -R $PAGES/* $TARGET
    for f in $TARGET/*.html
    do
        process_html $f
    done
}

html_latest () {
    latest_src=`ls -tr $PAGES/*.html | tail -1`
    cp $latest_src $TARGET
    cp ${latest_src%.*}.json $TARGET
    latest_target=`ls -tr $TARGET/*.html | tail -1`
    process_html $latest_target
}

process_html () {
    echo generando $1
    awk -i inplace '/<!--{{footer}}-->/{while(getline line<"'$TEMPLATES/footer.template'"){print line}} //' $1
    awk -i inplace '/<!--{{header}}-->/{while(getline line<"'$TEMPLATES/header.template'"){print line}} //' $1
    mustache ${1%.*}.json $1 > $TARGET/draft
    mv $TARGET/draft $1
    rm ${1%.*}.json
}

html_clean () {
	rm $TARGET/*.html
}

html_compress () {
    echo 'comprimiendo html'
    html-minifier --input-dir $TARGET --output-dir $TARGET --remove-comments --collapse-whitespace --conservative-collapse
}

js_compress() {
    echo 'comprimiendo js'
    uglifyjs $JS/clean-blog.js -c -m -o $ASSETS/js/clean-blog.min.js
    uglifyjs $JS/jqBootstrapValidation.js -c -m -o $ASSETS/js/jqBootstrapValidation.min.js
}

css_compress() {
    echo 'comprimiendo css'
    uglifycss $CSS/clean-blog.css > $ASSETS/css/clean-blog.min.css
    uglifycss $CSS/monokai.css > $ASSETS/css/monokai.min.css
}

copy_root_files() {
    cp -R $ROOT/* $TARGET
    cp $ROOT/.htaccess $TARGET
}

mrproper() {
    rm $ASSETS/css/clean-blog.css
    find $ASSETS -type f -name "*.map" -exec rm {} \;
}

case "$1" in
    clean)
		clean
        ;;
    sass_watch)
        sass_watch
        css_compress
        ;;
    html_watch)
        html_latest
        ;;
    package)
        clean
        prepare
		sass_compile
        css_compress
        js_compress
		html_all
        ;;
    release)
        clean
        prepare
        html_all
        sass_compress        
        html_compress
        js_compress
        css_compress
        copy_root_files
        mrproper
        ;;
    *)
        echo "Usa 'clean', 'sass_watch', 'html_watch', 'package' o 'release'"
        echo ""
        ;;
esac


