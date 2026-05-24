/******************************************************************************/
/* Prolog Lab 2 example - Grammar test bed                                    */
/******************************************************************************/
:- consult('cmreader.pl').
:- dynamic single_character/1.
:- dynamic readword/3.
:- retractall(single_character(58)).
:- asserta((readword(C, W, C2) :- C = 58, get0(C1), readwordaux(C, W, C1, C2))).

readwordaux(C, W, C1, C2) :- C1 = 61, name(W, [C, C1]), get0(C2).
readwordaux(C, W, C1, C2) :- C1 \= 61, name(W, [C]), C1 = C2.

lpar   -->[40].     % ( 
rpar   -->[41].     % ) 
mult   -->[42].     % * 
plus   -->[43].     % + 
comma  -->[44].     % , 
dot    -->[46].     % . 
colon  -->[58].     % : 
scolon -->[59].     % ; 


prog    -->[256].
input   -->[257].
output  -->[258].
var     -->[259].
integer -->[260].
begin   -->[261].
end     -->[262].
boolean -->[263].
real    -->[264].
identifier  -->[270].
assign  -->[271].
number  -->[272].
undef   -->[273].
eof     -->[275].




lexer([], []).
lexer([H|T], [F|S]) :-
    match(H, F), 
    !,
    lexer(T, S).
    
match(-1, 275).

match('program', 256).
match('input', 257). 
match('output', 258).
match('var', 259). 
match('integer', 260).
match('begin', 261). 
match('end', 262). 
match('boolean', 263).
match('real', 264). 
match('id', 270). 
match(':=', 271). 

match('(', 40).
match(')', 41).
match('*', 42).
match('+', 43).
match(',', 44).
match('.', 46).
match(':', 58).
match(';', 59).


match(w, 270) :- atom(w), \+ match(w, _).
match(n, 272) :- number(w).
match(_,273).


/******************************************************************************/
/* Grammar Rules in Definite Clause Grammar form                              */
/* This the set of productions, P, for this grammar                           */
/* This is a slightly modified from of the Pascal Grammar for Lab 2 Prolog    */
/******************************************************************************/

program       --> prog_head, var_part, stat_part.

/******************************************************************************/
/* Program Header                                                             */
/******************************************************************************/
prog_head     --> [prog], id, ['('], [input], [','], [output], [')'], [';'].
id            --> [a]|[b]|[c].

/******************************************************************************/
/* Var_part                                                                   */
/******************************************************************************/
var_part        --> [var], var_dec_list.
var_dec_list    --> var_dec, var_dec_list | var_dec .
var_dec         --> id_list, [':'], typ, [';'].
id_list         --> [identifier], id_list | [identifier].
typ             --> [integer] | [boolean] | [real].


/******************************************************************************/
/* Stat part                                                                  */
/******************************************************************************/
stat_part       --> [begin], stat_list, [end], ['.'].
stat_list       --> stat, stat_list| stat.
stat            --> assign_stat.
assign_stat     --> [identifier], [assign], expr.
expr            --> term, ['+'], expr | term.
term            --> factor, ['*'], term | factor.
factor          --> ['('], expr, [')'] | operand.
operand         --> [identifier] | [number].

/******************************************************************************/
/* Testing the system: this may be done stepwise in Prolog                    */
/* below are some examples of a "bottom-up" approach - start with simple      */
/* tests and buid up until a whole program can be tested                      */
/******************************************************************************/
/* Stat part                                                                  */
/******************************************************************************/
/*  op(['+'], []).                                                            */
/*  op(['-'], []).                                                            */
/*  op(['*'], []).                                                            */
/*  op(['/'], []).                                                            */
/*  addop(['+'], []).                                                         */
/*  addop(['-'], []).                                                         */
/*  mulop(['*'], []).                                                         */
/*  mulop(['/'], []).                                                         */
/*  factor([a], []).                                                          */
/*  factor(['(', a, ')'], []).                                                */
/*  term([a], []).                                                            */
/*  term([a, '*', a], []).                                                    */
/*  expr([a], []).                                                            */
/*  expr([a, '*', a], []).                                                    */
/*  assign_stat([a, assign, b], []).                                          */
/*  assign_stat([a, assign, b, '*', c], []).                                  */
/*  stat([a, assign, b], []).                                                 */
/*  stat([a, assign, b, '*', c], []).                                         */
/*  stat_list([a, assign, b], []).                                            */
/*  stat_list([a, assign, b, '*', c], []).                                    */
/*  stat_list([a, assign, b, ';', a, assign, c], []).                         */
/*  stat_list([a, assign, b, '*', c, ';', a, assign, b, '*', c], []).         */
/*  stat_part([begin, a, assign, b, '*', c, end, '.'], []).                   */
/******************************************************************************/
/* Var part                                                                   */
/******************************************************************************/
/* typ([integer], []).                                                        */
/* typ([real], []).                                                           */
/* typ([boolean], []).                                                        */
/* id([a], []).                                                               */
/* id([b], []).                                                               */
/* id([c], []).                                                               */
/* id_list([a], []).                                                          */
/* id_list([a, ',', b], []).                                                  */
/* id_list([a, ',', b, ',', c], []).                                          */
/* var_dec([a, ':', integer], []).                                            */
/* var_dec_list([a, ':', integer], []).                                       */
/* var_dec_list([a, ':', integer, b, ':', real], []).                         */
/* var_part([var, a, ':', integer], []).                                      */
/******************************************************************************/
/* Program header                                                             */
/******************************************************************************/
/* prog_head([program, c, '(', input, ',', output, ')', ';'], []).            */
/******************************************************************************/

/******************************************************************************/
/* Whole program                                                              */
/******************************************************************************/
/* program([program, c, '(', input, ',', output, ')', ';',                    */
/*          var, a,    ':', integer, ';',                                     */
/*               b, ',', c, ':', real,    ';',                                */
/*          begin,                                                            */
/*             a, assign, b, '*', c, ';',                                     */  
/*             a, assign, b, '+', c,                                          */
/*          end, '.'], []).                                                   */
/******************************************************************************/

/******************************************************************************/
/* Define the above tests                                                     */
/******************************************************************************/

testph :- prog_head([program, c, '(', input, ',', output, ')', ';'], []).
testpr :-   program([program, c, '(', input, ',', output, ')', ';'], []).

/******************************************************************************/
/* End of program                                                             */
/******************************************************************************/
