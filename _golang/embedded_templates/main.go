package main

import (
	"embed"
	"html/template"
	"os"
)

//go:embed templates/*
var templateFS embed.FS

func unescape(s string) template.HTML {
	return template.HTML(s)
}

func getTemplate() *template.Template {

	// allows you to process strings in the template like
	// {{ .Something | unescape }}
	funcMap := template.FuncMap{
		"unescape": unescape,
	}
	tmpl := template.New("").Funcs(funcMap)

	// find templates in ./templates
	tmpl = template.Must(tmpl.ParseFS(templateFS, "templates/*.tmpl.html"))
	return tmpl
}

func useTemplate() {
	tmpl := getTemplate()

	data := struct {
		Name   string
		Things []string
	}{
		Name:   "dog",
		Things: []string{"a", "b", "c"},
	}
	// holds result of template
	err := tmpl.ExecuteTemplate(os.Stdout, "hello.tmpl.html", data)
	if err != nil {
		panic(err)
	}
}

func main() {
	useTemplate()
}
