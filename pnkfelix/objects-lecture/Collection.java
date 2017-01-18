public abstract class Collection 
{
    public static class Pair { 
        Object x; Collection y;
        Pair(Object theX, Collection theY) { x = theX; y = theY; }
    }

    /* These are *abstract* methods that our concrete subclasses will 
     * have to implement. */
    public abstract boolean         isEmpty();
    public abstract Collection      addElem( Object x );
    public abstract Collection.Pair anyElem();

    /* These are *concrete* methods that are shared amongst all of our
     * subclasses.  Thus we have automatic code reuse. */
    public          Collection      addAll(Collection other_collection) {
        if (other_collection.isEmpty()) {
            return this;
        } else {
            Pair       val_and_other_rest = other_collection.anyElem();
            Object     val                = val_and_other_rest.x;
            Collection other_rest         = val_and_other_rest.y;
            return this.addElem(val).addAll( other_rest );
        }
    }
    public          String          toString() {
        return "( " + this.toItemsString() + ")";
    }
    private         String          toItemsString() {
        if (this.isEmpty()) {
            return "";
        } else {
            Pair       val_and_other_rest = this.anyElem();
            Object     val                = val_and_other_rest.x;
            Collection other_rest         = val_and_other_rest.y;
            return (val.toString() + " " + other_rest.toItemsString());
        }
    }
}
