/******************************************************************************/
/* Prolog Lab 2 example - Grammar test bed                                    */
/******************************************************************************/
:- consult('cmreader.pl').
:- dynamic single_character/1.
:- dynamic readword/3.
:- retractall(single_character(58)).
:- asserta((readword(C, W, C2) :- C = 58, get0(C1), readwordaux(C, W, C1, C2))).
:- asserta((readword(C, W, C2) :- C > 47, C < 58, get0(C1), restword(C1, Cs, C2), name(W, [C|Cs]), number(W))).

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


prog        -->[256].
input       -->[257].
output      -->[258].
variable    -->[259].
int         -->[260].
begin       -->[261].
end         -->[262].
boolean     -->[263].
real        -->[264].
identifier  -->[270].
assign      -->[271].
numb        -->[272].
undef       -->[273].
eof         -->[275].




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
match(':=', 271).
match('(', 40).
match(')', 41).
match('*', 42).
match('+', 43).
match(',', 44).
match('.', 46).
match(':', 58).
match(';', 59).


match(W, 270) :- atom(W), \+ member(W, ['program', 'input', 'output', 'var', 'integer', 'begin', 'end', 'boolean', 'real', ':=', '=','(', ')', '*', '+', ',', '.', ':', ';']).
match(W, 272) :- number(W).
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
prog_head       --> [256], id, [40], [257], [44], [258], [41], [59].
id              --> [270].

/******************************************************************************/
/* Var_part                                                                   */
/******************************************************************************/
var_part        --> [259], var_dec_list.
var_dec_list    --> var_dec, var_dec_list | var_dec .
var_dec         --> id_list, [58], typ, [59].
id_list         --> [270], [44], id_list | [270].
typ             --> [260] | [263] | [264].


/******************************************************************************/
/* Stat part                                                                  */
/******************************************************************************/
stat_part       --> [261], stat_list, [262], [46].
stat_list       --> stat, [59], stat_list| stat.
stat            --> assign_stat.
assign_stat     --> [270], [271], expr.
expr            --> term, [43], expr | term.
term            --> factor, [42], term | factor.
factor          --> [40], expr, [41] | operand.
operand         --> [270] | [272].

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
parser(Tokens, Res) :-
    (program(Tokens, Res), Res = [] -> write('Parse OK!') ; write('Parse Fail!')).


testph :- prog_head([program, c, '(', input, ',', output, ')', ';'], []).
testpr :-   program([program, c, '(', input, ',', output, ')', ';'], []).

testok :- parseFiles(['testfiles/testok1.pas',
                      'testfiles/testok2.pas',
                      'testfiles/testok3.pas',
                      'testfiles/testok4.pas',
                      'testfiles/testok5.pas',
                      'testfiles/testok6.pas',
                      'testfiles/testok7.pas']).

lab3 :-
    tell('parser.out'),
    write('Testing OK programs '), nl, nl,
    parseFiles(['testfiles/testok1.pas', 'testfiles/testok2.pas', 'testfiles/testok3.pas',
                'testfiles/testok4.pas', 'testfiles/testok5.pas', 'testfiles/testok6.pas',
                'testfiles/testok7.pas']),
    write('Testing a-z programs '), nl, nl,
    parseFiles(['testfiles/testa.pas', 'testfiles/testb.pas', 'testfiles/testc.pas',
                'testfiles/testd.pas', 'testfiles/teste.pas', 'testfiles/testf.pas',
                'testfiles/testg.pas', 'testfiles/testh.pas', 'testfiles/testi.pas',
                'testfiles/testj.pas', 'testfiles/testk.pas', 'testfiles/testl.pas',
                'testfiles/testm.pas', 'testfiles/testn.pas', 'testfiles/testo.pas',
                'testfiles/testp.pas', 'testfiles/testq.pas', 'testfiles/testr.pas',
                'testfiles/tests.pas', 'testfiles/testt.pas', 'testfiles/testu.pas',
                'testfiles/testv.pas', 'testfiles/testw.pas', 'testfiles/testx.pas',
                'testfiles/testy.pas', 'testfiles/testz.pas']),
    write('Testing fun programs '), nl, nl,
    parseFiles(['testfiles/fun1.pas', 'testfiles/fun2.pas', 'testfiles/fun3.pas',
                'testfiles/fun4.pas', 'testfiles/fun5.pas']),
    write('Testing sem programs '), nl, nl,
    parseFiles(['testfiles/sem1.pas', 'testfiles/sem2.pas', 'testfiles/sem3.pas',
                'testfiles/sem4.pas', 'testfiles/sem5.pas']),
    told.

parseFiles([ ]).
parseFiles([H|T]) :-
    write('Testing '), write(H), nl,
    read_in(H, L), write(L), nl,
    lexer(L, Tokens), write(Tokens), nl,
    parser(Tokens, _),
    nl, write(H), write(' end of parse'), nl, nl,
    parseFiles(T).
/******************************************************************************/
/* End of program                                                             */
/******************************************************************************/
