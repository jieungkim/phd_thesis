// container in C (and in memory)
typedef struct _container{
    uint quota;
    uint usage;
    uint parent;
    uint nchildren;
    uint used;
    uint csize;
}container;

container CPool[num_proc];