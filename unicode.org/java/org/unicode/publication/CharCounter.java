package org.unicode.publication;

import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.helpers.DefaultHandler;

import com.ibm.icu.lang.UCharacter;
import com.ibm.icu.lang.UCharacterCategory;
import com.ibm.icu.text.Normalizer2;
import com.ibm.icu.text.UCharacterIterator;
import com.ibm.icu.text.UTF16;


public class CharCounter {
  public static class DocumentConsumer extends DefaultHandler {
    StringBuffer sb = new StringBuffer ();
    
    public void characters (char[] chars, int start, int length) {
      sb.append (chars, start, length);
    }
  }
  
  static boolean isCombining (int ch) {
	    int gc = UCharacter.getType (ch);
	    return (   gc == UCharacterCategory.COMBINING_SPACING_MARK
	             || gc == UCharacterCategory.NON_SPACING_MARK
	             || gc == UCharacterCategory.ENCLOSING_MARK);
	  }


  static public String toU (int n) {
    return toU (Integer.toHexString (n));
  }

  static public String toU (String s) {
    if ("".equals (s)) { 
      return s; }
    while (s.length () < 4) {
      s = "0" + s; }
    return s.toUpperCase ();
  }
  
  static public String toU2 (String s) {
    String prefix = "";
    StringBuffer sb = new StringBuffer ();
    UCharacterIterator it = UCharacterIterator.getInstance (s);
    for (int i = 0; i < UTF16.countCodePoint (s); i++) {
      int usv = it.nextCodePoint ();
      sb.append (prefix);
      prefix = ", ";
      sb.append (toU (usv)); }
    while (sb.length () < 16) {
      sb.append (' '); }
    return sb.toString ();
  }
  
  static String charName (int usv) {
    if (usv == 0x102b) {
      return "MYANMAR VOWEL SIGN TALL AA"; }
    if (usv == 0x103a) {
      return "MYANMAR SIGN ASAT"; }
    if (usv == 0x103b) {
      return "MYANMAR CONSONANT SIGN MEDIAL YA"; }
    if (usv == 0x103c) {
      return "MYANMAR CONSONANT SIGN MEDIAL RA"; }
    if (usv == 0x103d) {
      return "MYANMAR CONSONANT SIGN MEDIAL WA"; }
    if (usv == 0x103e) {
      return "MYANMAR CONSONANT SIGN MEDIAL HA"; }
    if (usv == 0x103F) {
      return "MYANMAR LETTER GREAT SA"; }
    return UCharacter.getName (usv); 
  }

    
  static public String toN (String s) {
    String prefix = "";
    StringBuffer sb = new StringBuffer ();
    UCharacterIterator it = UCharacterIterator.getInstance (s);
    for (int i = 0; i < UTF16.countCodePoint (s); i++) {
      int usv = it.nextCodePoint ();
      sb.append (prefix);
      prefix = ", ";
      sb.append (charName (usv)); }

    return sb.toString ();
  }
    
    
  static public String rightPad (String s, int n) {
    while (s.length () <= n) {
      s = s + " "; }
    return s;
  }

  static public String leftPad (String s, int n) {
    while (s.length () <= n) {
      s = " " + s; }
    return s;
  }
  
  static public boolean isVirama (int usv) {
    return usv == 0x094d // viramas
    || usv == 0x09cd
    || usv == 0x0a4d
    || usv == 0x0acd
    || usv == 0x0b4d
    || usv == 0x0bcd
    || usv == 0x0c4d
    || usv == 0x0ccd
    || usv == 0x0d4d
    || usv == 0x0dca
    || usv == 0x0e3a
    || usv == 0x1039
    || usv == 0x1714
    || usv == 0x1734
    || usv == 0x17d2
    || usv == 0x1b44
    || usv == 0xa806
    || usv == 0x10a3f;
  }

  static public boolean isNotGluing (int usv) {
    return usv == 0x0a || usv == 0x0d || usv == 0x09;
  }
  
  static public boolean isGluing (int usv) {
    return isCombining (usv) 
    || usv== 0x200c || usv == 0x200d // joiners
    || isVirama (usv)
    || usv == 0x102b || (0x1039 <= usv && usv <= 0x103e); // new Myanmar chars
  }
  
  static public boolean isCapturedByVirama (int usv) {
    // very crude
    return 0x900 <= usv && usv < 0x1100;
  }
  /** Print stats about the characters present in a StringBuffer.
   * 
   * @param sb
   */
  public static void printStats (StringBuffer sb) {
    String s = Normalizer2.getNFDInstance().normalize(sb.toString ());
    Map<String, Integer> counter = new TreeMap<String, Integer> ();
    
    UCharacterIterator it2 = UCharacterIterator.getInstance (s);
    int[] usvs = new int [UTF16.countCodePoint (s)];
    for (int i = 0; i < usvs.length; i++) {
      usvs [i] = it2.nextCodePoint (); }
    
    int i = 0;
    while (i < usvs.length) {
      int j = i + 1;
      boolean lastIsVirama = false;
      while (   j < usvs.length 
             && (   (lastIsVirama && isCapturedByVirama (usvs [j]))
                 || isGluing (usvs [j]))) {
        j++;
        lastIsVirama = isVirama (usvs [j-1]); }
      
      if (UCharacter.isWhitespace (usvs [i]) && j == i + 1) {
        i = j;
        continue; }
      
      StringBuffer sb2 = new StringBuffer ();
      for (int k = i; k < j; k++) {
        UTF16.append (sb2, usvs [k]); }
      String grapheme = sb2.toString ();
      
      Integer count = counter.get (grapheme);
      if (count != null) {
        count = count.intValue () + 1; }
      else {
        count = 1; }
      counter.put (grapheme, count);
      i = j; }
    
    int leftColumnWidth = 0;
    for (Iterator<String> it = counter.keySet ().iterator (); it.hasNext (); ) {
      String grapheme = it.next ();
      leftColumnWidth = Math.max (leftColumnWidth, toU2 (grapheme).length ()); }
    leftColumnWidth++;
    
    for (Iterator<String> it = counter.keySet ().iterator (); it.hasNext (); ) {
      String grapheme = it.next ();
      String n = toN (grapheme);
      if (n != null) {
        System.out.println (rightPad (toU2 (grapheme) + " ", leftColumnWidth)
            + "\t" + leftPad ((counter.get (grapheme)).toString (), 6) + "   "
            + "\t" + toN (grapheme)); }}
  }
  
  public static void main (String[] args) throws Exception {
    DocumentConsumer l = new DocumentConsumer ();
    SAXParserFactory.newInstance ().newSAXParser ().parse (args [0], l);
    printStats (l.sb);
  }
  
}
