#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Hair Salon ~~~~~\n"
MAIN_MENU () {
  SERVICES=$($PSQL "SELECT service_id,name FROM services;")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  echo -e "\nSelect a service:"
  read SERVICE_ID_SELECTED
  if [[ -z $SERVICE_ID_SELECTED ]]
  then
    MAIN_MENU
  else
    #check input
    if [[ $SERVICE_ID_SELECTED > 0 && $SERVICE_ID_SELECTED < 4 ]]
    then
      echo "Enter your phone number:"
      read CUSTOMER_PHONE
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
      if [[ -z $CUSTOMER_NAME ]]
      then
        echo "Enter your name:"
        read CUSTOMER_NAME
        INSERT_INTO_CUSTOMERS=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME');")
        echo "You are a new customer"
        #insert new customer
      else
        echo "Welcome back $CUSTOMER_NAME."
      fi
      #get_customer_id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
      echo "Enter a time:"
      read SERVICE_TIME
      INSERT_INTO_APPS=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")
      if [[ -z $INSERT_INTO_APPS ]]
      then
        echo -e "\nThere was a error adding your appointment. Please try again."
        MAIN_MENU
      else
        SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
        echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME." 
      fi
    else
      echo -e "No service selected.\n"
      MAIN_MENU 
    fi
  fi
}
MAIN_MENU
