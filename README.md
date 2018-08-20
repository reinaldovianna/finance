### Getting Started

Instalação de dependencias:
	bundle installl

Configuração da base de dados
	rake db:migrate
	rake db:seed


### Start cronjob
	crontab -r
	
	whenever --update-crontab --set environment=<<ambiente>>
	
	Ex.: whenever --update-crontab --set environment='development'

### Install geckodriver

A instalação desse recurso é necessário para conseguir executar os testes de browser

    wget https://github.com/mozilla/geckodriver/releases/download/v0.11.1/geckodriver-v0.11.1-linux64.tar.gz
    tar -xvzf geckodriver-v0.11.1-linux64.tar.gz
    rm geckodriver-v0.11.1-linux64.tar.gz
    chmod +x geckodriver
    cp geckodriver /usr/local/bin/