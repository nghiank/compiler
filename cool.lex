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
    case STRING:
      System.err.println("EOF in string constant");
      break;
    case COMMENT:
      System.err.println("EOF in comment");
      break;
    }
    return new Symbol(TokenConstants.EOF,yyline,1);
%eofval}

%class CoolLexer
%cup
%state COMMENT,STRING
%line

COMMENT_TEXT=([^\*\(\n]|[^\(\n]\*[^\)\n]|[^\*\n]\)|\([^\*\n])*
NON_NEWLINE_SPACE=[\ \f\r\v\t\b]
DIGIT=[0-9]

%%

<YYINITIAL,COMMENT>\n {}
<YYINITIAL>"*)" {
  System.out.println("Unmatched *)");
}
<YYINITIAL>"(*"     {
  /* System.out.println("start comment state");  */
  yybegin(COMMENT);
}
<COMMENT>"*)" {
  /* System.out.println("finish comment state");  */
  yybegin(YYINITIAL);
}
<COMMENT>{COMMENT_TEXT} {
 // System.out.println("found some comment:" + yytext()); 
}
<YYINITIAL>"=>"			{ /* Sample lexical rule for "=>" arrow.
                                     Further lexical rules should be defined
                                     here, after the last %% separator */
  return new Symbol(TokenConstants.DARROW,yyline,1); 
}
<YYINITIAL>{NON_NEWLINE_SPACE}+ {

}
<YYINITIAL>"class" {
  return new Symbol(TokenConstants.CLASS,yyline,1); 
}
<YYINITIAL>"*" {
  return new Symbol(TokenConstants.MULT,yyline,1); 
}
<YYINITIAL>"-" {
  return new Symbol(TokenConstants.MINUS,yyline,1); 
}
<YYINITIAL>"/" {
  return new Symbol(TokenConstants.DIV,yyline,1); 
}
<YYINITIAL>"+" {
  return new Symbol(TokenConstants.PLUS,yyline,1); 
}
<YYINITIAL>":" {
  return new Symbol(TokenConstants.COLON,yyline,1); 
}
<YYINITIAL>"inherits" {
  return new Symbol(TokenConstants.INHERITS,yyline,1); 
}
<YYINITIAL>"pool" {
  return new Symbol(TokenConstants.POOL,yyline,1); 
}
<YYINITIAL>"case" {
  return new Symbol(TokenConstants.CASE,yyline,1); 
}
<YYINITIAL>"not" {
  return new Symbol(TokenConstants.NOT,yyline,1); 
}
<YYINITIAL>"(" {
  return new Symbol(TokenConstants.LPAREN,yyline,1); 
}
<YYINITIAL>")" {
  return new Symbol(TokenConstants.RPAREN,yyline,1); 
}
<YYINITIAL>";" {
  return new Symbol(TokenConstants.SEMI,yyline,1); 
}
<YYINITIAL>"<" {
  return new Symbol(TokenConstants.LT,yyline,1); 
}
<YYINITIAL>"in" {
  return new Symbol(TokenConstants.IN,yyline,1);
}
<YYINITIAL>"," {
  return new Symbol(TokenConstants.COMMA,yyline,1);
}
<YYINITIAL>"fi" {
  return new Symbol(TokenConstants.FI,yyline,1); 
}
<YYINITIAL>"loop" {
  return new Symbol(TokenConstants.LOOP,yyline,1); 
}
<YYINITIAL>"<-" {
  return new Symbol(TokenConstants.ASSIGN,yyline,1); 
}
<YYINITIAL>"if" {
  return new Symbol(TokenConstants.IF,yyline,1); 
}
<YYINITIAL>"." {
  return new Symbol(TokenConstants.DOT,yyline,1); 
}
<YYINITIAL>"<=" {
  return new Symbol(TokenConstants.LE,yyline,1); 
}
<YYINITIAL>"of" {
  return new Symbol(TokenConstants.OF,yyline,1); 
}
<YYINITIAL>"new" {
  return new Symbol(TokenConstants.NEW,yyline,1);
}
<YYINITIAL>"is_void" {
  return new Symbol(TokenConstants.PLUS,yyline,1); 
}
<YYINITIAL>"=" {
  return new Symbol(TokenConstants.EQ,yyline,1); 
}
<YYINITIAL>"~" {
  return new Symbol(TokenConstants.NEG,yyline,1); 
}
<YYINITIAL>"{" {
  return new Symbol(TokenConstants.LBRACE,yyline,1); 
}
<YYINITIAL>"}" {
  return new Symbol(TokenConstants.RBRACE,yyline,1); 
}
<YYINITIAL>"else" {
  return new Symbol(TokenConstants.ELSE,yyline,1); 
}
<YYINITIAL>"while" {
  return new Symbol(TokenConstants.WHILE,yyline,1); 
}
<YYINITIAL>"esac" {
  return new Symbol(TokenConstants.ESAC,yyline,1); 
}
<YYINITIAL>"let" {
  return new Symbol(TokenConstants.LET,yyline,1); 
}
<YYINITIAL>"then" {
  return new Symbol(TokenConstants.PLUS,yyline,1); 
}
<YYINITIAL>\" {
  string_buf.setLength(0);
  System.out.println("Start string here"); 
  yybegin(STRING);
}
<STRING>[^\\\"]\n {
  System.err.println("Unterminated string constant"); 
  return new Symbol(TokenConstants.ERROR,yyline,1);
}
<STRING>\0 {
  System.err.println("String contains null character"); 
  return new Symbol(TokenConstants.ERROR,yyline,1);
}
<STRING>[^\n\\\"]+ {
  System.out.println("append:"+yytext()); 
  string_buf.append(yytext());
}
<STRING>(\\\n)+ {
}
<STRING>(\\[^\n\"])+ {
  System.out.println("append:"+yytext()); 
  string_buf.append(yytext());
}
<STRING>\" {
  System.out.println("Found string:" + string_buf.toString()); 
  yybegin(YYINITIAL);
  AbstractSymbol symbol = AbstractTable.stringtable.addString(string_buf.toString(), MAX_STR_CONST);
  return new Symbol(TokenConstants.STR_CONST,yyline,1, symbol);
}
<YYINITIAL>{DIGIT}+ {
  Integer val = Integer.parseInt(yytext());
  AbstractSymbol symbol = AbstractTable.inttable.addInt(val);
  return new Symbol(TokenConstants.INT_CONST,yyline,1, symbol); 
}
<YYINITIAL>"true"|"false" {
  if (yytext().equals("true")) {
    return new Symbol(TokenConstants.BOOL_CONST,yyline,1, BoolConst.truebool);
  } else {
    return new Symbol(TokenConstants.BOOL_CONST,yyline,1, BoolConst.falsebool);
  }
}
<YYINITIAL>[A-Z][_0-9a-zA-Z]* {
  AbstractSymbol symbol = AbstractTable.stringtable.addString(yytext(), MAX_STR_CONST);
  return new Symbol(TokenConstants.TYPEID,yyline,1, symbol);
}
<YYINITIAL>[a-z][_0-9a-zA-Z]* {
  AbstractSymbol symbol = AbstractTable.stringtable.addString(yytext(), MAX_STR_CONST);
  return new Symbol(TokenConstants.OBJECTID,yyline,1, symbol);
}
. { 
  System.err.println("LEXER BUG - UNMATCHED: " + yytext()); 
  System.out.println("LEXER BUG - UNMATCHED: " + yytext()); 
}
