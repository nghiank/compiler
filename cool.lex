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

    private int comment_level = 0;
    private boolean valid_string = true;
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
      yybegin(YYINITIAL);
      return new Symbol(TokenConstants.ERROR,yyline,1, "EOF in string constant");
    case COMMENT:
      yybegin(YYINITIAL);
      return new Symbol(TokenConstants.ERROR,yyline,1, "EOF in comment");
    }
    return new Symbol(TokenConstants.EOF,yyline,1);
%eofval}

%class CoolLexer
%cup
%state COMMENT,STRING
%line

COMMENT_TEXT=(\\[^\*\)\(]|[^\*\(\)\\]|\*\\\)|\\\(\*|\*\\\)|\(\\\*|\\\*\)|[^\(]\*[^\)\*]|[^\*]\)|\([^\*]|\*+[^\*\)])

INLINE_COMMENT=--.*\n
NON_NEWLINE_SPACE=[\ \f\r\t\b]
DIGIT=[0-9]

%%

<YYINITIAL>{NON_NEWLINE_SPACE}+ {
  //System.out.println("space:"+ yytext());
}
<YYINITIAL,COMMENT>\n {
}
<YYINITIAL>"*)") {
  /* System.err.println("Unmatched *)"); */
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.ERROR,yyline,1, "Unmatched *)"); 
}
<YYINITIAL,COMMENT>"(*"     {
  /* System.out.println("increase comment state"); */
  comment_level++;
  yybegin(COMMENT);
}
<YYINITIAL>{INLINE_COMMENT} {
}
<COMMENT>\*+\) {
  --comment_level;
  /* System.out.println("decrease comment state"); */
  if (comment_level == 0) {
    yybegin(YYINITIAL);
  }
}
<COMMENT>{COMMENT_TEXT}* {
  /* System.out.println("found some comment:" + yytext()+ "->length=" + Integer.toString(yytext().length()));   */
}
<YYINITIAL>"=>"			{ /* Sample lexical rule for "=>" arrow.
                                     Further lexical rules should be defined
                                     here, after the last %% separator */
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.DARROW,yyline,1); 
}
<YYINITIAL>[cC][lL][aA][sS][sS] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.CLASS,yyline,1); 
}
<YYINITIAL>"*" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.MULT,yyline,1); 
}
<YYINITIAL>"-" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.MINUS,yyline,1); 
}
<YYINITIAL>"/" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.DIV,yyline,1); 
}
<YYINITIAL>"+" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.PLUS,yyline,1); 
}
<YYINITIAL>":" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.COLON,yyline,1); 
}
<YYINITIAL>"@" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.AT,yyline,1); 
}
<YYINITIAL>[iI][nN][hH][eE][rR][iI][tT][sS] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.INHERITS,yyline,1); 
}
<YYINITIAL>[pP][oO][oO][lL] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.POOL,yyline,1); 
}
<YYINITIAL>[cC][aA][sS][eE] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.CASE,yyline,1); 
}
<YYINITIAL>[nN][oO][tT] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.NOT,yyline,1); 
}
<YYINITIAL>"(" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.LPAREN,yyline,1); 
}
<YYINITIAL>")" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.RPAREN,yyline,1); 
}
<YYINITIAL>";" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.SEMI,yyline,1); 
}
<YYINITIAL>"<" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.LT,yyline,1); 
}
<YYINITIAL>[iI][nN] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.IN,yyline,1);
}
<YYINITIAL>"," {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.COMMA,yyline,1);
}
<YYINITIAL>[fF][iI] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.FI,yyline,1); 
}
<YYINITIAL>[lL][oO][oO][pP] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.LOOP,yyline,1); 
}
<YYINITIAL>"<-" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.ASSIGN,yyline,1); 
}
<YYINITIAL>[iI][fF] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.IF,yyline,1); 
}
<YYINITIAL>"." {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.DOT,yyline,1); 
}
<YYINITIAL>"<=" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.LE,yyline,1); 
}
<YYINITIAL>[oO][fF] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.OF,yyline,1); 
}
<YYINITIAL>[nN][eE][wW] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.NEW,yyline,1);
}
<YYINITIAL>[iI][sS][vV][oO][iO][dD] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.ISVOID,yyline,1); 
}
<YYINITIAL>"=" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.EQ,yyline,1); 
}
<YYINITIAL>"~" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.NEG,yyline,1); 
}
<YYINITIAL>"{" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.LBRACE,yyline,1); 
}
<YYINITIAL>"}" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.RBRACE,yyline,1); 
}
<YYINITIAL>[eE][lL][sS][eE] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.ELSE,yyline,1); 
}
<YYINITIAL>[wW][hH][iI][lL][eE] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.WHILE,yyline,1); 
}
<YYINITIAL>[eE][sS][aA][cC] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.ESAC,yyline,1); 
}
<YYINITIAL>[lL][eE][tT] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.LET,yyline,1); 
}
<YYINITIAL>[tT][hH][eE][nN] {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.THEN,yyline,1); 
}
<YYINITIAL>\" {
  /* System.out.println("String started");  */
  string_buf.setLength(0);
  valid_string = true;
  yybegin(STRING);
}
<STRING>\n {
  String error = "Unterminated string constant"; 
  yybegin(YYINITIAL);
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.ERROR,yyline,1, error);
}
<STRING>\0.*\n? {
  String error = "String contains null character"; 
  valid_string = false;
  curr_lineno = yyline + 1;
  yybegin(YYINITIAL);
  return new Symbol(TokenConstants.ERROR,yyline,1, error);
}
<STRING>\\ {
  string_buf.append(yytext());
}
<STRING>[^\n\\\"\0]+ {
/* System.out.println("hello world:" + yytext()); */
  /* System.out.println("text:"+yytext()+"$");  */
  string_buf.append(yytext());
}
<STRING>(\\\") {
    string_buf.append('"');
}
<STRING>(\\\n) {
    string_buf.append('\n');
}
<STRING>(\\[^\n\"\0]) {
/* System.out.println("hello world:" + yytext()); */
  if (yytext().equals("\\n")) {
  /* System.out.println("hello world1:" + yytext()); */
    string_buf.append('\n');
  } else if (yytext().equals("\\b")) {
    string_buf.append('\b');
  } else if (yytext().equals("\\t")) {
    string_buf.append('\t');
  } else if (yytext().equals("\\f")) {
    string_buf.append('\f');
  } else {
    string_buf.append(yytext().charAt(1));
  /* System.out.println("hello 1:" + yytext()); */
  }
}

<STRING>\" {
  yybegin(YYINITIAL);
  /* System.out.println("hello 1:" + yytext()); */
  curr_lineno = yyline + 1;
  if (valid_string)  {
  /* System.out.println("hello 1:" + string_buf.length()); */
    if (string_buf.length() <  MAX_STR_CONST) {
      AbstractSymbol symbol = AbstractTable.stringtable.addString(string_buf.toString(), MAX_STR_CONST);
      return new Symbol(TokenConstants.STR_CONST,yyline,1, symbol);
    } else {
      return new Symbol(TokenConstants.ERROR,yyline,1, "String constant too long");
    }
  }
}
<YYINITIAL>{DIGIT}+ {
  curr_lineno = yyline + 1;
  AbstractSymbol symbol = AbstractTable.stringtable.addString(yytext());
  return new Symbol(TokenConstants.INT_CONST,yyline,1, symbol); 
}
<YYINITIAL>t[rR][uU][eE]|f[aA][lL][sS][eE] {
  curr_lineno = yyline + 1;
  if (yytext().equalsIgnoreCase("true")) {
    return new Symbol(TokenConstants.BOOL_CONST,yyline,1, true);
  } else {
    return new Symbol(TokenConstants.BOOL_CONST,yyline,1, false);
  }
}
<YYINITIAL>[A-Z][_0-9a-zA-Z]* {
  curr_lineno = yyline + 1;
  AbstractSymbol symbol = AbstractTable.stringtable.addString(yytext(), MAX_STR_CONST);
  return new Symbol(TokenConstants.TYPEID,yyline,1, symbol);
}
<YYINITIAL>"_" {
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.ERROR,yyline,1, "_");
}

<YYINITIAL>[a-z][_0-9a-zA-Z]* {
  curr_lineno = yyline + 1;
//  System.out.println("Objectidd="+ yytext());
  AbstractSymbol symbol = AbstractTable.stringtable.addString(yytext(), MAX_STR_CONST);
  return new Symbol(TokenConstants.OBJECTID,yyline,1, symbol);
}

. { 
  /* System.out.println("LEXER BUG - UNMATCHED: " + yytext() + ":" + Integer.toString(yyline)); */
  curr_lineno = yyline + 1;
  return new Symbol(TokenConstants.ERROR,yyline,2, yytext());
}
