public abstract class Tree extends Collection 
{
    public abstract boolean isLeaf();
    public abstract Tree    left();      /* only non-leaf works! */
    public abstract Tree    right();     /* only non-leaf works! */
    public abstract Object  nodeValue(); /* only non-leaf works! */

    public boolean          isEmpty() { return this.isLeaf(); }
    public Tree             addElem(Object v) { 
        return Tree.node(this, Tree.leaf(), v); 
    }
    public Collection.Pair  anyElem() {
        if (this.isLeaf()) {
            throw new RuntimeException("cant-use-some-elem-on-empty-trees!");
        } else if (this.left().isLeaf()) {
            return new Collection.Pair( this.nodeValue(), this.right() );
        } else if (this.right().isLeaf()) {
            return new Collection.Pair( this.nodeValue(), this.left() );
        } else {
            Collection.Pair val_and_rest = this.left().anyElem();
            Object          lft_val      = val_and_rest.x;
            Tree            lft_rest     = (Tree) val_and_rest.y;
            return new Collection.Pair( lft_val, 
                                        Tree.node( lft_rest, 
                                                   this.right(), 
                                                   this.nodeValue() ));
        }
    }

    public static Tree node( Tree lft, Tree rgt, Object val ) { 
        return new Node( lft, rgt, val );
    }
    public static Tree leaf() {
        return new Leaf();
    }

    private static class Leaf extends Tree 
    {
        public boolean isLeaf()    { return true; }
        public Object  nodeValue() { throw errmsg("leaves don't have values");   }
        public Tree    left()      { throw errmsg("leaves don't have subtrees"); }
        public Tree    right()     { throw errmsg("leaves don't have subtrees"); }
    }

    private static class Node extends Tree 
    {
        Object val;
        Tree lft;
        Tree rgt;
        Node( Tree theLeft, Tree theRight, Object theVal ) {
            this.val = theVal;
            this.lft = theLeft;
            this.rgt = theRight;
        }
        public boolean isLeaf()    { return false; }
        public Object  nodeValue() { return this.val; }
        public Tree    left()      { return this.lft; }
        public Tree    right()     { return this.rgt; }
    }

    private static RuntimeException errmsg( String s ) {
        return new RuntimeException( s );
    }
}
