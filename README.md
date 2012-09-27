Bulls and Cows
==============

A Ruby-based "Bulls and Cows" game originally written for CS 5390 (Computer Networks).

About
-----

This project demonstrates creating a client and server project in Ruby. The server will pick a random number with no repeating digits that is between 3 and 6 digits, based on a length provided by the client. The client tries to guess the number that the server has chosen. The server responds with a number of bulls and a number of cows. The number of bulls is the number of digis that are of the correct value and correct position. The number of cows is the number of digits that are the correct value but in the wrong position. The client wins by guessing the correct number, and the server will let the client know how many guesses it took to guess the number.

Example
-------

Client wants to play with a 4-digit number.
The server picks 1769.
The client chooses 1234.
Server responds 1 bull, 0 cows.
Client chooses 1678.
Server responds 1 bull, 2 cows.
Client chooses 1476.
Server responds 2 bulls, 1 cow.
Client chooses 1769.
Server responds 4 bulls: guessed correctly in 4 tries