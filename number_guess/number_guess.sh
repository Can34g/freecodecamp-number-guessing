#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c";


MAIN(){

    SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
    GUESS_COUNTER=1;
    
    USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$INPUT'; ")
    if [[ -z $USERNAME  ]]
    then 
        echo "Welcome, $INPUT! It looks like this is your first time here."
        GAMES_PLAYED=1;
        USERNAME=$INPUT;
    else
        GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME'; ");
        BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'; ");
        echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
        ((GAMES_PLAYED++));
        
   
    fi
    echo "$SECRET_NUMBER"
    echo -e "\nGuess the secret number between 1 and 1000:"
    read GUESS
    IS_INTEGER $GUESS
    CHECK $GUESS
    if [[ -z $BEST_GAME ]]
    then
        REGISTER=$($PSQL "INSERT INTO users(username,games_played, best_game) VALUES('$USERNAME',$GAMES_PLAYED, $GUESS_COUNTER);");
    else
        REGISTER=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE username = '$USERNAME';");
    if [[ $BEST_GAME -gt $GUESS_COUNTER ]] 
    then 
        
        REGISTER2=$($PSQL "UPDATE users SET best_game = $GUESS_COUNTER WHERE username = '$USERNAME';");
        echo "$REGISTER"
    fi
    fi
    echo  "You guessed it in $GUESS_COUNTER tries. The secret number was $SECRET_NUMBER. Nice job!"
    

    
}
    IS_INTEGER(){
    
            until [[ $GUESS =~ ^[0-9]+$ ]]
            do
            echo "That is not an integer, guess again:"
            read GUESS
            done
        
    }
    CHECK(){
      
    until [[  $GUESS == $SECRET_NUMBER  ]]
    do
    IS_INTEGER $GUESS
    if [[  $GUESS -lt $SECRET_NUMBER  ]] 
    then
        echo "It's higher than that, guess again:";
        ((GUESS_COUNTER++));
        read GUESS
    
    else
        echo "It's lower than that, guess again:";
        ((GUESS_COUNTER++));
        read GUESS


    fi

    done

}
    

START(){
    echo "Enter your username:"
    read INPUT
    MAIN $INPUT
    
  
}
START
