#!/usr/bin/env bash
set -e

DEVTOOLS_HOME="${HOME}/.devtools"

if [ -d ${DEVTOOLS_HOME} ]
then
	echo "You already have devtools installed!"
	readline -p "Would you like to remove the old installation? (yes/no) "
	if [ ${LINE} == "yes" ]
	then
	  rm -rf ${DEVTOOLS_HOME}
	else
		exit 1
	fi
fi

REQUIRED=(git dart pub)

for TOOL in ${REQUIRED}
do
	which ${TOOL} 2>&1 >/dev/null
	if [ ${?} != 0 ]
	then
		echo "ERROR: Unable to find '${TOOL}' on path!"
		exit 1
	fi
done

echo "Cloning Repository..."

git clone --quiet git://github.com/DirectMyFile/devtools.git ${DEVTOOLS_HOME} >/dev/null

cd ${DEVTOOLS_HOME}

echo "Fetching Dependencies..."

pub get >/dev/null

if [ -f ${HOME}/.config/fish/config.fish ]
then
  echo "set -gx PATH \$PATH ${DEVTOOLS_HOME}/scripts" >> ${HOME}/.config/fish/config.fish
fi

echo "export PATH=\${PATH}:${DEVTOOLS_HOME}/scripts" >> ${HOME}/.bashrc

echo "devtools has been successfully installed!"