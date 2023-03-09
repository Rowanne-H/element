#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

NO_ELEMENT="I could not find that element in the database."

PRINT() {
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  ATOMIC_NUMBER_F=$(echo $ATOMIC_NUMBER | sed 's/ |/"/') 
  SYMBOL_F=$(echo $SYMBOL | sed 's/ |/"/') 
  NAME_F=$(echo $NAME | sed 's/ |/"/')
  TYPE_F=$(echo $TYPE | sed 's/ |/"/')
  ATOMIC_MASS_F=$(echo $ATOMIC_MASS | sed 's/ |/"/')
  MELTING_POINT_CELSIUS_F=$(echo $MELTING_POINT_CELSIUS | sed 's/ |/"/')
  BOILING_POINT_CELSIUS_F=$(echo $BOILING_POINT_CELSIUS | sed 's/ |/"/')

  echo "The element with atomic number $ATOMIC_NUMBER_F is $NAME_F ($SYMBOL_F). It's a $TYPE_F, with a mass of $ATOMIC_MASS_F amu. $NAME_F has a melting point of $MELTING_POINT_CELSIUS_F celsius and a boiling point of $BOILING_POINT_CELSIUS_F celsius."
}

if [[ $1 ]]
then
  if [[ $1 = [0-9]* ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1") 
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo $NO_ELEMENT
    else
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
      PRINT
    fi      
  else
    if [[ $1 =~ ^[A-Z][a-z]* ]]
    then
      if [[ $1 =~ [A-Z][a-z][a-z]+ ]]
      then
        NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
        if [[ -z $NAME ]]
        then
          echo $NO_ELEMENT
        else
          SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
          ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
          PRINT
        fi
      else
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
        if [[ -z $SYMBOL ]]
        then
          echo $NO_ELEMENT
        else
          ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
          NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
          PRINT
        fi
      fi
    else
      echo $NO_ELEMENT
    fi       
  fi
else
  echo "Please provide an element as an argument."
fi

  
