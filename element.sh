#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  # for some reason not passing in here
  echo "Please provide an element as an argument."
  exit 0
fi 

length=$(echo -n $1 | wc -m)

if [[ "$1" =~ ^[0-9]+$ ]]; then
    # echo "Variable '$1' is an Integer."
    # rm type_id if nec
    values=$($PSQL "select atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol,   name  ,   type from properties left join elements using(atomic_number) left join types using(type_id) where atomic_number = '$1'")
  else
    if [[ $length == 1 || $length == 2 ]]; then
      # echo "one char string"
      values=$($PSQL "select atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol,   name  ,   type from properties left join elements using(atomic_number) left join types using(type_id) where symbol = '$1'")
    else 
      # echo "multi char string"    
      values=$($PSQL "select atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol,   name  ,   type from properties left join elements using(atomic_number) left join types using(type_id) where name = '$1'")
    fi
  fi

# echo $values
if [[ -z $values ]]; then
  echo "I could not find that element in the database."
else 
  echo "$values" | while IFS="|" read atomic_number atomic_mass melting_point_celsius boiling_point_celsius symbol name type  
    do
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
    done

fi