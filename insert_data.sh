#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate teams,games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  if [[ $WINNER != winner ]]
    then
    WINNER_TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    if [[ -z $WINNER_TEAM_ID ]]
    then
      INSERT_WINNER_TEAM_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_WINNER_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $WINNER
      fi
      WINNER_TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi
    OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      INSERT_OPPONENT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_OPPONENT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
      OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi
    INSERT_GAME_RESULT=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
    values('$YEAR','$ROUND','$WINNER_TEAM_ID','$OPPONENT_TEAM_ID','$WINNERGOALS','$OPPONENTGOALS')")
    if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
    then
      echo Inserted into games, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNERGOALS $OPPONENTGOALS
    fi
  fi
done
