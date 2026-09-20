#!/bin/bash
curl -s "wttr.in/Joao_Pessoa?format=%t" | sed 's/+//'
