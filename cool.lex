/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
	/* nothing special to do in the initial state */
	break;
	/* If necessary, add code for other states here, e.g:
	   case COMMENT:
	   ...
	   break;
	*/
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup
%state COMMENT

COMMENT_TEXT=([^\*\(\n]|[^\(\n]\*[^\)\n]|[^\*\n]\)|\([^\*\n])*
NON_NEWLINE_SPACE=[\ \t\b]

%%

<YYINITIAL,COMMENT>\n {}
<YYINITIAL>"(*"     {
  System.out.println("start comment state"); 
  yybegin(COMMENT);
}
<COMMENT>"*)" {
  System.out.println("finish comment state"); 
  yybegin(YYINITIAL);
}
<COMMENT>{COMMENT_TEXT} {
 // System.out.println("found some comment:" + yytext()); 
}

<YYINITIAL>"=>"			{ /* Sample lexical rule for "=>" arrow.
                                     Further lexical rules should be defined
                                     here, after the last %% separator */
  return new Symbol(TokenConstants.DARROW); 
}
<YYINITIAL>{NON_NEWLINE_SPACE}+ {

}
<YYINITIAL>"class" {
  return new Symbol(TokenConstants.CLASS); 
}
<YYINITIAL>"*" {
  return new Symbol(TokenConstants.MULT); 
}
<YYINITIAL>"-" {
  return new Symbol(TokenConstants.MINUS); 
}
<YYINITIAL>"/" {
  return new Symbol(TokenConstants.DIV); 
}
<YYINITIAL>"+" {
  return new Symbol(TokenConstants.PLUS); 
}
<YYINITIAL>":" {
  return new Symbol(TokenConstants.COLON); 
}
<YYINITIAL>"inherits" {
  return new Symbol(TokenConstants.INHERITS); 
}
<YYINITIAL>"pool" {
  return new Symbol(TokenConstants.POOL); 
}
<YYINITIAL>"case" {
  return new Symbol(TokenConstants.CASE); 
}
<YYINITIAL>"not" {
  return new Symbol(TokenConstants.NOT); 
}
<YYINITIAL>"(" {
  return new Symbol(TokenConstants.LPAREN); 
}
<YYINITIAL>")" {
  return new Symbol(TokenConstants.RPAREN); 
}
<YYINITIAL>";" {
  return new Symbol(TokenConstants.SEMI); 
}
<YYINITIAL>"<" {
  return new Symbol(TokenConstants.LT); 
}
<YYINITIAL>"in" {
  return new Symbol(TokenConstants.IN);
}
<YYINITIAL>"," {
  return new Symbol(TokenConstants.COMMA);
}
<YYINITIAL>"fi" {
  return new Symbol(TokenConstants.FI); 
}
<YYINITIAL>"loop" {
  return new Symbol(TokenConstants.LOOP); 
}
<YYINITIAL>"<-" {
  return new Symbol(TokenConstants.ASSIGN); 
}
<YYINITIAL>"if" {
  return new Symbol(TokenConstants.IF); 
}
<YYINITIAL>"." {
  return new Symbol(TokenConstants.DOT); 
}
<YYINITIAL>"<=" {
  return new Symbol(TokenConstants.LE); 
}
<YYINITIAL>"of" {
  return new Symbol(TokenConstants.OF); 
}
<YYINITIAL>"new"{
  return new Symbol(TokenConstants.NEW);
}
<YYINITIAL>"is_void" {
  return new Symbol(TokenConstants.PLUS); 
}
<YYINITIAL>"=" {
  return new Symbol(TokenConstants.EQ); 
}
<YYINITIAL>"~" {
  return new Symbol(TokenConstants.NEG); 
}
<YYINITIAL>"{" {
  return new Symbol(TokenConstants.LBRACE); 
}
<YYINITIAL>"}" {
  return new Symbol(TokenConstants.RBRACE); 
}
<YYINITIAL>"else" {
  return new Symbol(TokenConstants.ELSE); 
}
<YYINITIAL>"while" {
  return new Symbol(TokenConstants.WHILE); 
}
<YYINITIAL>"esac" {
  return new Symbol(TokenConstants.ESAC); 
}
<YYINITIAL>"let" {
  return new Symbol(TokenConstants.LET); 
}
<YYINITIAL>"then" {
  return new Symbol(TokenConstants.THEN); 
}
. { 
  System.err.println("LEXER BUG - UNMATCHED: " + yytext()); 
  System.out.println("LEXER BUG - UNMATCHED: " + yytext()); 
}
