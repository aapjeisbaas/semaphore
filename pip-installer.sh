#!/bin/sh
# pull in all requirements from the 
pip install --upgrade pip
find /usr/share/ansible/ -type f -iname '*requirements.txt' -exec cat "{}" \; | grep -ve 'python_version\|antsibull\|git\+\|docker-compose' | sed 's/#.*//g; s/>=.*//g; s/~=.*//g; s/==.*//g; s/>.*//g; s/<.*//g; s/[[:space:]]*$//g; s/\!=.*//g;  /^$/d'  | sort | uniq >> reqs.txt
while read p; do python3 -c "import $p" || python3 -m pip show "$p" || echo "$p" >> requirements.txt ; done < reqs.txt

# for debug purposes
echo "Contents of requirements.txt:"
cat requirements.txt
echo "End of requirements.txt"

# check if packages are instalable
for package in $(cat requirements.txt); do
    pip install $package --dry-run
    if [ $? -eq 0 ]; then
        echo $package >> checked-requirements.txt
    else
        echo $package >> failed-requirements.txt
    fi
done

# for debug purposes
echo "Contents of failed-requirements.txt:"
cat failed-requirements.txt
echo "End of failed-requirements.txt"


pip3 install --debug -r checked-requirements.txt --ignore-installed packaging PyYAML

