// allocates a WOS
int WS_alloc(char *metadata, int size, segno_t *newsegno);

// trims a segment
int WS_trim(segno_t seg); 

// batch captures a sub-range within the WOS
int WOS_capture(segno_t seg, int *retcodes, off_t start,
    off_t end);

// batch writes a sub-range within the WOS
int WOS_write(segno_t seg, char *buf, int size,
    int *retcodes, off_t start, off_t stop);

// registers a listener for write notifications
int WOS_listen(segno_t seg, callback_t listener);

// captures a WOR
int WOR_capture(segno_t seg, off_t addr, int *captureID);

// writes a single WOR
int WOR_write(segno_t seg, off_t addr, char *buf, int size,
    int captureID);

// reads a single WOR
int WOR_read(segno_t seg, off_t addr, char *buf, int size);