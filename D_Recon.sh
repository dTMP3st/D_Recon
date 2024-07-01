#!/bin/bash

# clear

if [ "$1" == "" ]; then
	echo "Forma de uso: $0 <URL>"
else
	setterm -foreground green
	echo ""
	echo "+--------------- DNS Recon ---------------+"
	echo ""
	echo "Developed by: Cyber Strike Force LAB's"
	echo ""
	echo "Fazendo consulta do tipo SOA ..."
	SOA=$(host -t SOA $1)
	echo "Fazendo consulta do tipo A ..."
	A=$(host -t A $1)
	echo "Fazendo consulta do tipo AAAA ..."
	AAAA=$(host -t AAAA $1)
	echo "Fazendo consulta do tipo NS ..."
	host -t NS $1 | grep "name server" | cut -d " " -f4 >> NS.txt
	NS=$(cat NS.txt)
	echo "Fazendo consulta do tipo CNAME ..."
	CNAME=$(host -t CNAME $1)
	echo "Fazendo consulta do tipo MX ..."
	MX=$(host -t MX $1)
	echo "Fazendo consulta do tipo PTR ..."
	PTR=$(host -t PTR $1)
	echo "Fazendo consulta do tipo HINFO ..."
	HINFO=$(host -t HINFO $1)
	echo "Fazendo consulta do tipo TXT ..."
	TXT=$(host -t TXT $1)
	# SPF=$(host -t TXT $1 | grep "SPF" | egrep "-|~|?")
	echo ""

	setterm -foreground red
	echo "=============== Resultado ==============="
	echo ""
	echo "Endereço: $1"
	echo ""
	echo "	[+] Consulta SOA: $SOA" | grep -v "has no"
	echo "	[+] Consulta A: $A" | grep -v "has no"
	echo "	[+] Consulta AAAA: $AAAA" | grep -v "has no"
	echo "	[+] Consulta NS: $NS" | grep -v "has no"
	echo "	[+] Consulta CNAME: $CNAME" | grep -v "has no"
	echo "	[+] Consulta MX: $MX" | grep -v "has no"
	echo "	[+] Consulta PTR: $PTR" | grep -v "has no"
	echo "	[+] Consulta HINFO: $HINFO" | grep -v "has no"
	echo "	[+] Consulta TXT: $TXT" | grep -v "has no"
	echo ""
	echo "[*] Testando transferência de zona ..."
	# Para a execução da transferência de zona é necessário que a porta 53 TCP esteja aberta.
	for NameS in $(cat NS.txt); do
		ZoneTransfer=$(host -l $1 $NameS | grep "5(REFUSED)")
		if [ "$ZoneTransfer" == "" ]; then
                        echo "	[+] Transferência de Zona feita com sucesso"
                        host -l -a $1 $NameS
		else
			echo "	[-] A transferência de zona falhou - $NameS ..."
		fi
	done
	#if [ "$SPF" == "" ]; then
fi
rm NS.txt
setterm -foreground default
