public class Queue extends Collection 
{
    private Object[] elems;
    private Queue( Object[] theElems ) { this.elems = theElems; }
    /* The standard queue messages are below. */
    public Queue           snoc(Object x) { 
        return new Queue( array_append( this.elems, new Object[] { x } ) );
    }
    public boolean         isEmpty()    { return array_isNull(elems);            }
    public Object          head()       { return array_car(elems);               }
    public Queue           tail()       { return new Queue( array_cdr( elems )); }

    public static Queue    empty()      { return new Queue( array_null() );      }

    /* But we also need to implement the abstract methods
     * of Collection. */
    public Queue           addElem( Object val ) { return this.snoc(val); }
    public Collection.Pair anyElem() { 
        return new Collection.Pair( this.head(), this.tail() ); 
    }

    /*** Don't look below this line!  ***/


    /*** You've been warned.          ***/


    /* The rest of this is very gross code that should not be used for
     * any real system anywhere ever; its all just a hack to get a
     * semi-applicative programming style even in an imperative
     * language like Java. */
    private static boolean  array_isNull( Object[] x ) { return x.length == 0; }
    private static Object[] array_null()               { return new Object[0]; }
    private static Object   array_car( Object[] x )    { return x[0];          }
    private static Object[] array_cdr( Object[] x ) {
        Object[] z = new Object[x.length - 1];
        System.arraycopy( x, 1, z, 0, x.length - 1);
        return z;
    }
    static Object[] array_append( Object[] x, Object[] y ) {
        Object[] z = new Object[x.length + y.length];
        System.arraycopy( x, 0, z, 0, x.length );
        System.arraycopy( y, 0, z, x.length, y.length );
        return z;
    }
}
