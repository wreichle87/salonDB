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
        echo "Welcome back$CUSTOMER_NAME."
      fi
      #get_customer_id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
      echo -e "$CUSTOMER_ID is the customer id."
      echo "Enter a time:"
      read SERVICE_TIME
    else
      echo -e "No service selected.\n"
      MAIN_MENU 
    fi
  fi
}
MAIN_MENU



