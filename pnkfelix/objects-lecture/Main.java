public class Main 
{
    private static Tree leaf() { return Tree.leaf(); }
    private static Tree node( Tree l, Tree r, Object v ) {
        return Tree.node(l,r,v);
    }

    public static void main( String[] args ) {
        Queue q1 = Queue.empty();
        System.out.println("> q1.toString():\n" + q1.toString());
        Queue q2 = q1.addElem("a").addElem("b").addElem("c");
        System.out.println("> q2.toString():\n" + q2.toString());
        System.out.println("> q2.tail().toString():\n" + q2.tail().toString());

        Tree t1 = leaf();
        System.out.println("> t1.toString():\n" + t1.toString());
        Tree t2 = node( node( leaf(), leaf(), "p"), 
                        node( node( leaf(), leaf(), "q"),
                              node( leaf(), leaf(), "r"),
                              "s" ),
                        "t" );

        System.out.println("> t2.toString():\n" + t2.toString());

        System.out.println("> t2.isLeaf():\n" 
                           +  t2.isLeaf() );
        System.out.println("> t2.right().isLeaf():\n" 
                           +  t2.right().isLeaf() );
        System.out.println("> t2.left().isLeaf():\n" 
                           +  t2.left().isLeaf() );
        System.out.println("> t2.left().nodeValue():\n" 
                           +  t2.left().nodeValue() );
        System.out.println("> t2.right().toString():\n" 
                           +  t2.right().toString() );
        System.out.println("> q2.addAll(t2).toString():\n"
                           +  q2.addAll(t2).toString() );
    }
}
