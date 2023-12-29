MARKC=marked

.PHONY: all
all: index.html docker_cheat_sheet.html yaml_cheat_sheet.html

index.html: index.md docker_cheat_sheet.html yaml_cheat_sheet.html
	$(MARKC) -o $@ $<

docker_cheat_sheet.html: docker_cheat_sheet.md yaml_cheat_sheet.html
	$(MARKC) -o $@ $<

yaml_cheat_sheet.html: yaml_cheat_sheet.md
	$(MARKC) -o $@ $<

.PHONY: bdist
bdist: index.html docker_cheat_sheet.html yaml_cheat_sheet.html
	mkdir -p dist
	tar -czf dist/docker_containers_and_kubernetes_fundamentals_personal_notes_$(shell date +%Y%m%d%H%M%S).tar.gz $^

.PHONY: sdist
sdist: index.md docker_cheat_sheet.md yaml_cheat_sheet.md README
	mkdir -p dist
	tar -czf dist/docker_containers_and_kubernetes_fundamentals_personal_notes_$(shell date +%Y%m%d%H%M%S).src.tar.gz $^ Makefile

.PHONY: clean
clean:
	rm -f *html

.PHONY: dist-clean
dist-clean: clean
	rm -rf dist/
