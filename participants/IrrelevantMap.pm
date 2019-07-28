package IrrelevantMap;
use Exporter qw/import/;
our @EXPORT = qw/%irrelevant getIrrelevant isRelevant/;

our %irrelevant = (
    "cubeset=0/catmap=0" => {
        "cat: A cube:/rO/bA/g=" => "forward", 
        "cat: A cube:/rO/bA/g@" => "forward", 
        "cat: B cube:/rO/bV/g=" => "forward", 
        "cat: B cube:/rO/bV/g@" => "forward", 
        "cat: C cube:/rD/bA/g=" => "forward", 
        "cat: C cube:/rD/bA/g@" => "forward", 
        "cat: D cube:/rD/bV/g=" => "forward", 
        "cat: D cube:/rD/bV/g@" => "forward"
    }, 
    "cubeset=0/catmap=1" => {
        "cat: A cube:/rO/bA/g@" => "right", 
        "cat: A cube:/rO/bV/g@" => "right", 
        "cat: B cube:/rO/bA/g=" => "right", 
        "cat: B cube:/rO/bV/g=" => "right", 
        "cat: C cube:/rD/bA/g@" => "right", 
        "cat: C cube:/rD/bV/g@" => "right", 
        "cat: D cube:/rD/bA/g=" => "right", 
        "cat: D cube:/rD/bV/g=" => "right"
    }, 
    "cubeset=0/catmap=10" => {
        "cat: A cube:/rO/bV/g=" => "forward", 
        "cat: A cube:/rO/bV/g@" => "forward", 
        "cat: B cube:/rO/bA/g=" => "forward", 
        "cat: B cube:/rO/bA/g@" => "forward", 
        "cat: C cube:/rD/bV/g=" => "forward", 
        "cat: C cube:/rD/bV/g@" => "forward", 
        "cat: D cube:/rD/bA/g=" => "forward", 
        "cat: D cube:/rD/bA/g@" => "forward"
    }, 
    "cubeset=0/catmap=11" => {
        "cat: A cube:/rO/bV/g=" => "forward", 
        "cat: A cube:/rO/bV/g@" => "forward", 
        "cat: B cube:/rD/bV/g=" => "forward", 
        "cat: B cube:/rD/bV/g@" => "forward", 
        "cat: C cube:/rO/bA/g=" => "forward", 
        "cat: C cube:/rO/bA/g@" => "forward", 
        "cat: D cube:/rD/bA/g=" => "forward", 
        "cat: D cube:/rD/bA/g@" => "forward"
    }, 
    "cubeset=0/catmap=12" => {
        "cat: A cube:/rD/bV/g@" => "up", 
        "cat: A cube:/rO/bV/g@" => "up", 
        "cat: B cube:/rD/bV/g=" => "up", 
        "cat: B cube:/rO/bV/g=" => "up", 
        "cat: C cube:/rD/bA/g@" => "up", 
        "cat: C cube:/rO/bA/g@" => "up", 
        "cat: D cube:/rD/bA/g=" => "up", 
        "cat: D cube:/rO/bA/g=" => "up"
    }, 
    "cubeset=0/catmap=13" => {
        "cat: A cube:/rD/bV/g@" => "up", 
        "cat: A cube:/rO/bV/g@" => "up", 
        "cat: B cube:/rD/bA/g@" => "up", 
        "cat: B cube:/rO/bA/g@" => "up", 
        "cat: C cube:/rD/bV/g=" => "up", 
        "cat: C cube:/rO/bV/g=" => "up", 
        "cat: D cube:/rD/bA/g=" => "up", 
        "cat: D cube:/rO/bA/g=" => "up"
    }, 
    "cubeset=0/catmap=14" => {
        "cat: A cube:/rD/bV/g=" => "up", 
        "cat: A cube:/rO/bV/g=" => "up", 
        "cat: B cube:/rD/bV/g@" => "up", 
        "cat: B cube:/rO/bV/g@" => "up", 
        "cat: C cube:/rD/bA/g=" => "up", 
        "cat: C cube:/rO/bA/g=" => "up", 
        "cat: D cube:/rD/bA/g@" => "up", 
        "cat: D cube:/rO/bA/g@" => "up"
    }, 
    "cubeset=0/catmap=15" => {
        "cat: A cube:/rD/bV/g=" => "up", 
        "cat: A cube:/rO/bV/g=" => "up", 
        "cat: B cube:/rD/bA/g=" => "up", 
        "cat: B cube:/rO/bA/g=" => "up", 
        "cat: C cube:/rD/bV/g@" => "up", 
        "cat: C cube:/rO/bV/g@" => "up", 
        "cat: D cube:/rD/bA/g@" => "up", 
        "cat: D cube:/rO/bA/g@" => "up"
    }, 
    "cubeset=0/catmap=16" => {
        "cat: A cube:/rD/bA/g=" => "forward", 
        "cat: A cube:/rD/bA/g@" => "forward", 
        "cat: B cube:/rD/bV/g=" => "forward", 
        "cat: B cube:/rD/bV/g@" => "forward", 
        "cat: C cube:/rO/bA/g=" => "forward", 
        "cat: C cube:/rO/bA/g@" => "forward", 
        "cat: D cube:/rO/bV/g=" => "forward", 
        "cat: D cube:/rO/bV/g@" => "forward"
    }, 
    "cubeset=0/catmap=17" => {
        "cat: A cube:/rD/bA/g@" => "right", 
        "cat: A cube:/rD/bV/g@" => "right", 
        "cat: B cube:/rD/bA/g=" => "right", 
        "cat: B cube:/rD/bV/g=" => "right", 
        "cat: C cube:/rO/bA/g@" => "right", 
        "cat: C cube:/rO/bV/g@" => "right", 
        "cat: D cube:/rO/bA/g=" => "right", 
        "cat: D cube:/rO/bV/g=" => "right"
    }, 
    "cubeset=0/catmap=18" => {
        "cat: A cube:/rD/bA/g=" => "forward", 
        "cat: A cube:/rD/bA/g@" => "forward", 
        "cat: B cube:/rO/bA/g=" => "forward", 
        "cat: B cube:/rO/bA/g@" => "forward", 
        "cat: C cube:/rD/bV/g=" => "forward", 
        "cat: C cube:/rD/bV/g@" => "forward", 
        "cat: D cube:/rO/bV/g=" => "forward", 
        "cat: D cube:/rO/bV/g@" => "forward"
    }, 
    "cubeset=0/catmap=19" => {
        "cat: A cube:/rD/bA/g@" => "right", 
        "cat: A cube:/rD/bV/g@" => "right", 
        "cat: B cube:/rO/bA/g@" => "right", 
        "cat: B cube:/rO/bV/g@" => "right", 
        "cat: C cube:/rD/bA/g=" => "right", 
        "cat: C cube:/rD/bV/g=" => "right", 
        "cat: D cube:/rO/bA/g=" => "right", 
        "cat: D cube:/rO/bV/g=" => "right"
    }, 
    "cubeset=0/catmap=2" => {
        "cat: A cube:/rO/bA/g=" => "forward", 
        "cat: A cube:/rO/bA/g@" => "forward", 
        "cat: B cube:/rD/bA/g=" => "forward", 
        "cat: B cube:/rD/bA/g@" => "forward", 
        "cat: C cube:/rO/bV/g=" => "forward", 
        "cat: C cube:/rO/bV/g@" => "forward", 
        "cat: D cube:/rD/bV/g=" => "forward", 
        "cat: D cube:/rD/bV/g@" => "forward"
    }, 
    "cubeset=0/catmap=20" => {
        "cat: A cube:/rD/bA/g=" => "right", 
        "cat: A cube:/rD/bV/g=" => "right", 
        "cat: B cube:/rD/bA/g@" => "right", 
        "cat: B cube:/rD/bV/g@" => "right", 
        "cat: C cube:/rO/bA/g=" => "right", 
        "cat: C cube:/rO/bV/g=" => "right", 
        "cat: D cube:/rO/bA/g@" => "right", 
        "cat: D cube:/rO/bV/g@" => "right"
    }, 
    "cubeset=0/catmap=21" => {
        "cat: A cube:/rD/bA/g=" => "right", 
        "cat: A cube:/rD/bV/g=" => "right", 
        "cat: B cube:/rO/bA/g=" => "right", 
        "cat: B cube:/rO/bV/g=" => "right", 
        "cat: C cube:/rD/bA/g@" => "right", 
        "cat: C cube:/rD/bV/g@" => "right", 
        "cat: D cube:/rO/bA/g@" => "right", 
        "cat: D cube:/rO/bV/g@" => "right"
    }, 
    "cubeset=0/catmap=22" => {
        "cat: A cube:/rD/bV/g=" => "forward", 
        "cat: A cube:/rD/bV/g@" => "forward", 
        "cat: B cube:/rD/bA/g=" => "forward", 
        "cat: B cube:/rD/bA/g@" => "forward", 
        "cat: C cube:/rO/bV/g=" => "forward", 
        "cat: C cube:/rO/bV/g@" => "forward", 
        "cat: D cube:/rO/bA/g=" => "forward", 
        "cat: D cube:/rO/bA/g@" => "forward"
    }, 
    "cubeset=0/catmap=23" => {
        "cat: A cube:/rD/bV/g=" => "forward", 
        "cat: A cube:/rD/bV/g@" => "forward", 
        "cat: B cube:/rO/bV/g=" => "forward", 
        "cat: B cube:/rO/bV/g@" => "forward", 
        "cat: C cube:/rD/bA/g=" => "forward", 
        "cat: C cube:/rD/bA/g@" => "forward", 
        "cat: D cube:/rO/bA/g=" => "forward", 
        "cat: D cube:/rO/bA/g@" => "forward"
    }, 
    "cubeset=0/catmap=3" => {
        "cat: A cube:/rD/bA/g@" => "up", 
        "cat: A cube:/rO/bA/g@" => "up", 
        "cat: B cube:/rD/bA/g=" => "up", 
        "cat: B cube:/rO/bA/g=" => "up", 
        "cat: C cube:/rD/bV/g@" => "up", 
        "cat: C cube:/rO/bV/g@" => "up", 
        "cat: D cube:/rD/bV/g=" => "up", 
        "cat: D cube:/rO/bV/g=" => "up"
    }, 
    "cubeset=0/catmap=4" => {
        "cat: A cube:/rO/bA/g@" => "right", 
        "cat: A cube:/rO/bV/g@" => "right", 
        "cat: B cube:/rD/bA/g@" => "right", 
        "cat: B cube:/rD/bV/g@" => "right", 
        "cat: C cube:/rO/bA/g=" => "right", 
        "cat: C cube:/rO/bV/g=" => "right", 
        "cat: D cube:/rD/bA/g=" => "right", 
        "cat: D cube:/rD/bV/g=" => "right"
    }, 
    "cubeset=0/catmap=5" => {
        "cat: A cube:/rD/bA/g@" => "up", 
        "cat: A cube:/rO/bA/g@" => "up", 
        "cat: B cube:/rD/bV/g@" => "up", 
        "cat: B cube:/rO/bV/g@" => "up", 
        "cat: C cube:/rD/bA/g=" => "up", 
        "cat: C cube:/rO/bA/g=" => "up", 
        "cat: D cube:/rD/bV/g=" => "up", 
        "cat: D cube:/rO/bV/g=" => "up"
    }, 
    "cubeset=0/catmap=6" => {
        "cat: A cube:/rO/bA/g=" => "right", 
        "cat: A cube:/rO/bV/g=" => "right", 
        "cat: B cube:/rO/bA/g@" => "right", 
        "cat: B cube:/rO/bV/g@" => "right", 
        "cat: C cube:/rD/bA/g=" => "right", 
        "cat: C cube:/rD/bV/g=" => "right", 
        "cat: D cube:/rD/bA/g@" => "right", 
        "cat: D cube:/rD/bV/g@" => "right"
    }, 
    "cubeset=0/catmap=7" => {
        "cat: A cube:/rD/bA/g=" => "up", 
        "cat: A cube:/rO/bA/g=" => "up", 
        "cat: B cube:/rD/bA/g@" => "up", 
        "cat: B cube:/rO/bA/g@" => "up", 
        "cat: C cube:/rD/bV/g=" => "up", 
        "cat: C cube:/rO/bV/g=" => "up", 
        "cat: D cube:/rD/bV/g@" => "up", 
        "cat: D cube:/rO/bV/g@" => "up"
    }, 
    "cubeset=0/catmap=8" => {
        "cat: A cube:/rO/bA/g=" => "right", 
        "cat: A cube:/rO/bV/g=" => "right", 
        "cat: B cube:/rD/bA/g=" => "right", 
        "cat: B cube:/rD/bV/g=" => "right", 
        "cat: C cube:/rO/bA/g@" => "right", 
        "cat: C cube:/rO/bV/g@" => "right", 
        "cat: D cube:/rD/bA/g@" => "right", 
        "cat: D cube:/rD/bV/g@" => "right"
    }, 
    "cubeset=0/catmap=9" => {
        "cat: A cube:/rD/bA/g=" => "up", 
        "cat: A cube:/rO/bA/g=" => "up", 
        "cat: B cube:/rD/bV/g=" => "up", 
        "cat: B cube:/rO/bV/g=" => "up", 
        "cat: C cube:/rD/bA/g@" => "up", 
        "cat: C cube:/rO/bA/g@" => "up", 
        "cat: D cube:/rD/bV/g@" => "up", 
        "cat: D cube:/rO/bV/g@" => "up"
    }, 
    "cubeset=1/catmap=0" => {
        "cat: A cube:/rO/g=/bA" => "right", 
        "cat: A cube:/rO/g@/bA" => "right", 
        "cat: B cube:/rO/g=/bV" => "right", 
        "cat: B cube:/rO/g@/bV" => "right", 
        "cat: C cube:/rD/g=/bA" => "right", 
        "cat: C cube:/rD/g@/bA" => "right", 
        "cat: D cube:/rD/g=/bV" => "right", 
        "cat: D cube:/rD/g@/bV" => "right"
    }, 
    "cubeset=1/catmap=1" => {
        "cat: A cube:/rO/g@/bA" => "forward", 
        "cat: A cube:/rO/g@/bV" => "forward", 
        "cat: B cube:/rO/g=/bA" => "forward", 
        "cat: B cube:/rO/g=/bV" => "forward", 
        "cat: C cube:/rD/g@/bA" => "forward", 
        "cat: C cube:/rD/g@/bV" => "forward", 
        "cat: D cube:/rD/g=/bA" => "forward", 
        "cat: D cube:/rD/g=/bV" => "forward"
    }, 
    "cubeset=1/catmap=10" => {
        "cat: A cube:/rO/g=/bV" => "right", 
        "cat: A cube:/rO/g@/bV" => "right", 
        "cat: B cube:/rO/g=/bA" => "right", 
        "cat: B cube:/rO/g@/bA" => "right", 
        "cat: C cube:/rD/g=/bV" => "right", 
        "cat: C cube:/rD/g@/bV" => "right", 
        "cat: D cube:/rD/g=/bA" => "right", 
        "cat: D cube:/rD/g@/bA" => "right"
    }, 
    "cubeset=1/catmap=11" => {
        "cat: A cube:/rO/g=/bV" => "right", 
        "cat: A cube:/rO/g@/bV" => "right", 
        "cat: B cube:/rD/g=/bV" => "right", 
        "cat: B cube:/rD/g@/bV" => "right", 
        "cat: C cube:/rO/g=/bA" => "right", 
        "cat: C cube:/rO/g@/bA" => "right", 
        "cat: D cube:/rD/g=/bA" => "right", 
        "cat: D cube:/rD/g@/bA" => "right"
    }, 
    "cubeset=1/catmap=12" => {
        "cat: A cube:/rD/g@/bV" => "up", 
        "cat: A cube:/rO/g@/bV" => "up", 
        "cat: B cube:/rD/g=/bV" => "up", 
        "cat: B cube:/rO/g=/bV" => "up", 
        "cat: C cube:/rD/g@/bA" => "up", 
        "cat: C cube:/rO/g@/bA" => "up", 
        "cat: D cube:/rD/g=/bA" => "up", 
        "cat: D cube:/rO/g=/bA" => "up"
    }, 
    "cubeset=1/catmap=13" => {
        "cat: A cube:/rD/g@/bV" => "up", 
        "cat: A cube:/rO/g@/bV" => "up", 
        "cat: B cube:/rD/g@/bA" => "up", 
        "cat: B cube:/rO/g@/bA" => "up", 
        "cat: C cube:/rD/g=/bV" => "up", 
        "cat: C cube:/rO/g=/bV" => "up", 
        "cat: D cube:/rD/g=/bA" => "up", 
        "cat: D cube:/rO/g=/bA" => "up"
    }, 
    "cubeset=1/catmap=14" => {
        "cat: A cube:/rD/g=/bV" => "up", 
        "cat: A cube:/rO/g=/bV" => "up", 
        "cat: B cube:/rD/g@/bV" => "up", 
        "cat: B cube:/rO/g@/bV" => "up", 
        "cat: C cube:/rD/g=/bA" => "up", 
        "cat: C cube:/rO/g=/bA" => "up", 
        "cat: D cube:/rD/g@/bA" => "up", 
        "cat: D cube:/rO/g@/bA" => "up"
    }, 
    "cubeset=1/catmap=15" => {
        "cat: A cube:/rD/g=/bV" => "up", 
        "cat: A cube:/rO/g=/bV" => "up", 
        "cat: B cube:/rD/g=/bA" => "up", 
        "cat: B cube:/rO/g=/bA" => "up", 
        "cat: C cube:/rD/g@/bV" => "up", 
        "cat: C cube:/rO/g@/bV" => "up", 
        "cat: D cube:/rD/g@/bA" => "up", 
        "cat: D cube:/rO/g@/bA" => "up"
    }, 
    "cubeset=1/catmap=16" => {
        "cat: A cube:/rD/g=/bA" => "right", 
        "cat: A cube:/rD/g@/bA" => "right", 
        "cat: B cube:/rD/g=/bV" => "right", 
        "cat: B cube:/rD/g@/bV" => "right", 
        "cat: C cube:/rO/g=/bA" => "right", 
        "cat: C cube:/rO/g@/bA" => "right", 
        "cat: D cube:/rO/g=/bV" => "right", 
        "cat: D cube:/rO/g@/bV" => "right"
    }, 
    "cubeset=1/catmap=17" => {
        "cat: A cube:/rD/g@/bA" => "forward", 
        "cat: A cube:/rD/g@/bV" => "forward", 
        "cat: B cube:/rD/g=/bA" => "forward", 
        "cat: B cube:/rD/g=/bV" => "forward", 
        "cat: C cube:/rO/g@/bA" => "forward", 
        "cat: C cube:/rO/g@/bV" => "forward", 
        "cat: D cube:/rO/g=/bA" => "forward", 
        "cat: D cube:/rO/g=/bV" => "forward"
    }, 
    "cubeset=1/catmap=18" => {
        "cat: A cube:/rD/g=/bA" => "right", 
        "cat: A cube:/rD/g@/bA" => "right", 
        "cat: B cube:/rO/g=/bA" => "right", 
        "cat: B cube:/rO/g@/bA" => "right", 
        "cat: C cube:/rD/g=/bV" => "right", 
        "cat: C cube:/rD/g@/bV" => "right", 
        "cat: D cube:/rO/g=/bV" => "right", 
        "cat: D cube:/rO/g@/bV" => "right"
    }, 
    "cubeset=1/catmap=19" => {
        "cat: A cube:/rD/g@/bA" => "forward", 
        "cat: A cube:/rD/g@/bV" => "forward", 
        "cat: B cube:/rO/g@/bA" => "forward", 
        "cat: B cube:/rO/g@/bV" => "forward", 
        "cat: C cube:/rD/g=/bA" => "forward", 
        "cat: C cube:/rD/g=/bV" => "forward", 
        "cat: D cube:/rO/g=/bA" => "forward", 
        "cat: D cube:/rO/g=/bV" => "forward"
    }, 
    "cubeset=1/catmap=2" => {
        "cat: A cube:/rO/g=/bA" => "right", 
        "cat: A cube:/rO/g@/bA" => "right", 
        "cat: B cube:/rD/g=/bA" => "right", 
        "cat: B cube:/rD/g@/bA" => "right", 
        "cat: C cube:/rO/g=/bV" => "right", 
        "cat: C cube:/rO/g@/bV" => "right", 
        "cat: D cube:/rD/g=/bV" => "right", 
        "cat: D cube:/rD/g@/bV" => "right"
    }, 
    "cubeset=1/catmap=20" => {
        "cat: A cube:/rD/g=/bA" => "forward", 
        "cat: A cube:/rD/g=/bV" => "forward", 
        "cat: B cube:/rD/g@/bA" => "forward", 
        "cat: B cube:/rD/g@/bV" => "forward", 
        "cat: C cube:/rO/g=/bA" => "forward", 
        "cat: C cube:/rO/g=/bV" => "forward", 
        "cat: D cube:/rO/g@/bA" => "forward", 
        "cat: D cube:/rO/g@/bV" => "forward"
    }, 
    "cubeset=1/catmap=21" => {
        "cat: A cube:/rD/g=/bA" => "forward", 
        "cat: A cube:/rD/g=/bV" => "forward", 
        "cat: B cube:/rO/g=/bA" => "forward", 
        "cat: B cube:/rO/g=/bV" => "forward", 
        "cat: C cube:/rD/g@/bA" => "forward", 
        "cat: C cube:/rD/g@/bV" => "forward", 
        "cat: D cube:/rO/g@/bA" => "forward", 
        "cat: D cube:/rO/g@/bV" => "forward"
    }, 
    "cubeset=1/catmap=22" => {
        "cat: A cube:/rD/g=/bV" => "right", 
        "cat: A cube:/rD/g@/bV" => "right", 
        "cat: B cube:/rD/g=/bA" => "right", 
        "cat: B cube:/rD/g@/bA" => "right", 
        "cat: C cube:/rO/g=/bV" => "right", 
        "cat: C cube:/rO/g@/bV" => "right", 
        "cat: D cube:/rO/g=/bA" => "right", 
        "cat: D cube:/rO/g@/bA" => "right"
    }, 
    "cubeset=1/catmap=23" => {
        "cat: A cube:/rD/g=/bV" => "right", 
        "cat: A cube:/rD/g@/bV" => "right", 
        "cat: B cube:/rO/g=/bV" => "right", 
        "cat: B cube:/rO/g@/bV" => "right", 
        "cat: C cube:/rD/g=/bA" => "right", 
        "cat: C cube:/rD/g@/bA" => "right", 
        "cat: D cube:/rO/g=/bA" => "right", 
        "cat: D cube:/rO/g@/bA" => "right"
    }, 
    "cubeset=1/catmap=3" => {
        "cat: A cube:/rD/g@/bA" => "up", 
        "cat: A cube:/rO/g@/bA" => "up", 
        "cat: B cube:/rD/g=/bA" => "up", 
        "cat: B cube:/rO/g=/bA" => "up", 
        "cat: C cube:/rD/g@/bV" => "up", 
        "cat: C cube:/rO/g@/bV" => "up", 
        "cat: D cube:/rD/g=/bV" => "up", 
        "cat: D cube:/rO/g=/bV" => "up"
    }, 
    "cubeset=1/catmap=4" => {
        "cat: A cube:/rO/g@/bA" => "forward", 
        "cat: A cube:/rO/g@/bV" => "forward", 
        "cat: B cube:/rD/g@/bA" => "forward", 
        "cat: B cube:/rD/g@/bV" => "forward", 
        "cat: C cube:/rO/g=/bA" => "forward", 
        "cat: C cube:/rO/g=/bV" => "forward", 
        "cat: D cube:/rD/g=/bA" => "forward", 
        "cat: D cube:/rD/g=/bV" => "forward"
    }, 
    "cubeset=1/catmap=5" => {
        "cat: A cube:/rD/g@/bA" => "up", 
        "cat: A cube:/rO/g@/bA" => "up", 
        "cat: B cube:/rD/g@/bV" => "up", 
        "cat: B cube:/rO/g@/bV" => "up", 
        "cat: C cube:/rD/g=/bA" => "up", 
        "cat: C cube:/rO/g=/bA" => "up", 
        "cat: D cube:/rD/g=/bV" => "up", 
        "cat: D cube:/rO/g=/bV" => "up"
    }, 
    "cubeset=1/catmap=6" => {
        "cat: A cube:/rO/g=/bA" => "forward", 
        "cat: A cube:/rO/g=/bV" => "forward", 
        "cat: B cube:/rO/g@/bA" => "forward", 
        "cat: B cube:/rO/g@/bV" => "forward", 
        "cat: C cube:/rD/g=/bA" => "forward", 
        "cat: C cube:/rD/g=/bV" => "forward", 
        "cat: D cube:/rD/g@/bA" => "forward", 
        "cat: D cube:/rD/g@/bV" => "forward"
    }, 
    "cubeset=1/catmap=7" => {
        "cat: A cube:/rD/g=/bA" => "up", 
        "cat: A cube:/rO/g=/bA" => "up", 
        "cat: B cube:/rD/g@/bA" => "up", 
        "cat: B cube:/rO/g@/bA" => "up", 
        "cat: C cube:/rD/g=/bV" => "up", 
        "cat: C cube:/rO/g=/bV" => "up", 
        "cat: D cube:/rD/g@/bV" => "up", 
        "cat: D cube:/rO/g@/bV" => "up"
    }, 
    "cubeset=1/catmap=8" => {
        "cat: A cube:/rO/g=/bA" => "forward", 
        "cat: A cube:/rO/g=/bV" => "forward", 
        "cat: B cube:/rD/g=/bA" => "forward", 
        "cat: B cube:/rD/g=/bV" => "forward", 
        "cat: C cube:/rO/g@/bA" => "forward", 
        "cat: C cube:/rO/g@/bV" => "forward", 
        "cat: D cube:/rD/g@/bA" => "forward", 
        "cat: D cube:/rD/g@/bV" => "forward"
    }, 
    "cubeset=1/catmap=9" => {
        "cat: A cube:/rD/g=/bA" => "up", 
        "cat: A cube:/rO/g=/bA" => "up", 
        "cat: B cube:/rD/g=/bV" => "up", 
        "cat: B cube:/rO/g=/bV" => "up", 
        "cat: C cube:/rD/g@/bA" => "up", 
        "cat: C cube:/rO/g@/bA" => "up", 
        "cat: D cube:/rD/g@/bV" => "up", 
        "cat: D cube:/rO/g@/bV" => "up"
    }, 
    "cubeset=2/catmap=0" => {
        "cat: A cube:/bA/rO/g=" => "forward", 
        "cat: A cube:/bA/rO/g@" => "forward", 
        "cat: B cube:/bV/rO/g=" => "forward", 
        "cat: B cube:/bV/rO/g@" => "forward", 
        "cat: C cube:/bA/rD/g=" => "forward", 
        "cat: C cube:/bA/rD/g@" => "forward", 
        "cat: D cube:/bV/rD/g=" => "forward", 
        "cat: D cube:/bV/rD/g@" => "forward"
    }, 
    "cubeset=2/catmap=1" => {
        "cat: A cube:/bA/rO/g@" => "up", 
        "cat: A cube:/bV/rO/g@" => "up", 
        "cat: B cube:/bA/rO/g=" => "up", 
        "cat: B cube:/bV/rO/g=" => "up", 
        "cat: C cube:/bA/rD/g@" => "up", 
        "cat: C cube:/bV/rD/g@" => "up", 
        "cat: D cube:/bA/rD/g=" => "up", 
        "cat: D cube:/bV/rD/g=" => "up"
    }, 
    "cubeset=2/catmap=10" => {
        "cat: A cube:/bV/rO/g=" => "forward", 
        "cat: A cube:/bV/rO/g@" => "forward", 
        "cat: B cube:/bA/rO/g=" => "forward", 
        "cat: B cube:/bA/rO/g@" => "forward", 
        "cat: C cube:/bV/rD/g=" => "forward", 
        "cat: C cube:/bV/rD/g@" => "forward", 
        "cat: D cube:/bA/rD/g=" => "forward", 
        "cat: D cube:/bA/rD/g@" => "forward"
    }, 
    "cubeset=2/catmap=11" => {
        "cat: A cube:/bV/rO/g=" => "forward", 
        "cat: A cube:/bV/rO/g@" => "forward", 
        "cat: B cube:/bV/rD/g=" => "forward", 
        "cat: B cube:/bV/rD/g@" => "forward", 
        "cat: C cube:/bA/rO/g=" => "forward", 
        "cat: C cube:/bA/rO/g@" => "forward", 
        "cat: D cube:/bA/rD/g=" => "forward", 
        "cat: D cube:/bA/rD/g@" => "forward"
    }, 
    "cubeset=2/catmap=12" => {
        "cat: A cube:/bV/rD/g@" => "right", 
        "cat: A cube:/bV/rO/g@" => "right", 
        "cat: B cube:/bV/rD/g=" => "right", 
        "cat: B cube:/bV/rO/g=" => "right", 
        "cat: C cube:/bA/rD/g@" => "right", 
        "cat: C cube:/bA/rO/g@" => "right", 
        "cat: D cube:/bA/rD/g=" => "right", 
        "cat: D cube:/bA/rO/g=" => "right"
    }, 
    "cubeset=2/catmap=13" => {
        "cat: A cube:/bV/rD/g@" => "right", 
        "cat: A cube:/bV/rO/g@" => "right", 
        "cat: B cube:/bA/rD/g@" => "right", 
        "cat: B cube:/bA/rO/g@" => "right", 
        "cat: C cube:/bV/rD/g=" => "right", 
        "cat: C cube:/bV/rO/g=" => "right", 
        "cat: D cube:/bA/rD/g=" => "right", 
        "cat: D cube:/bA/rO/g=" => "right"
    }, 
    "cubeset=2/catmap=14" => {
        "cat: A cube:/bV/rD/g=" => "right", 
        "cat: A cube:/bV/rO/g=" => "right", 
        "cat: B cube:/bV/rD/g@" => "right", 
        "cat: B cube:/bV/rO/g@" => "right", 
        "cat: C cube:/bA/rD/g=" => "right", 
        "cat: C cube:/bA/rO/g=" => "right", 
        "cat: D cube:/bA/rD/g@" => "right", 
        "cat: D cube:/bA/rO/g@" => "right"
    }, 
    "cubeset=2/catmap=15" => {
        "cat: A cube:/bV/rD/g=" => "right", 
        "cat: A cube:/bV/rO/g=" => "right", 
        "cat: B cube:/bA/rD/g=" => "right", 
        "cat: B cube:/bA/rO/g=" => "right", 
        "cat: C cube:/bV/rD/g@" => "right", 
        "cat: C cube:/bV/rO/g@" => "right", 
        "cat: D cube:/bA/rD/g@" => "right", 
        "cat: D cube:/bA/rO/g@" => "right"
    }, 
    "cubeset=2/catmap=16" => {
        "cat: A cube:/bA/rD/g=" => "forward", 
        "cat: A cube:/bA/rD/g@" => "forward", 
        "cat: B cube:/bV/rD/g=" => "forward", 
        "cat: B cube:/bV/rD/g@" => "forward", 
        "cat: C cube:/bA/rO/g=" => "forward", 
        "cat: C cube:/bA/rO/g@" => "forward", 
        "cat: D cube:/bV/rO/g=" => "forward", 
        "cat: D cube:/bV/rO/g@" => "forward"
    }, 
    "cubeset=2/catmap=17" => {
        "cat: A cube:/bA/rD/g@" => "up", 
        "cat: A cube:/bV/rD/g@" => "up", 
        "cat: B cube:/bA/rD/g=" => "up", 
        "cat: B cube:/bV/rD/g=" => "up", 
        "cat: C cube:/bA/rO/g@" => "up", 
        "cat: C cube:/bV/rO/g@" => "up", 
        "cat: D cube:/bA/rO/g=" => "up", 
        "cat: D cube:/bV/rO/g=" => "up"
    }, 
    "cubeset=2/catmap=18" => {
        "cat: A cube:/bA/rD/g=" => "forward", 
        "cat: A cube:/bA/rD/g@" => "forward", 
        "cat: B cube:/bA/rO/g=" => "forward", 
        "cat: B cube:/bA/rO/g@" => "forward", 
        "cat: C cube:/bV/rD/g=" => "forward", 
        "cat: C cube:/bV/rD/g@" => "forward", 
        "cat: D cube:/bV/rO/g=" => "forward", 
        "cat: D cube:/bV/rO/g@" => "forward"
    }, 
    "cubeset=2/catmap=19" => {
        "cat: A cube:/bA/rD/g@" => "up", 
        "cat: A cube:/bV/rD/g@" => "up", 
        "cat: B cube:/bA/rO/g@" => "up", 
        "cat: B cube:/bV/rO/g@" => "up", 
        "cat: C cube:/bA/rD/g=" => "up", 
        "cat: C cube:/bV/rD/g=" => "up", 
        "cat: D cube:/bA/rO/g=" => "up", 
        "cat: D cube:/bV/rO/g=" => "up"
    }, 
    "cubeset=2/catmap=2" => {
        "cat: A cube:/bA/rO/g=" => "forward", 
        "cat: A cube:/bA/rO/g@" => "forward", 
        "cat: B cube:/bA/rD/g=" => "forward", 
        "cat: B cube:/bA/rD/g@" => "forward", 
        "cat: C cube:/bV/rO/g=" => "forward", 
        "cat: C cube:/bV/rO/g@" => "forward", 
        "cat: D cube:/bV/rD/g=" => "forward", 
        "cat: D cube:/bV/rD/g@" => "forward"
    }, 
    "cubeset=2/catmap=20" => {
        "cat: A cube:/bA/rD/g=" => "up", 
        "cat: A cube:/bV/rD/g=" => "up", 
        "cat: B cube:/bA/rD/g@" => "up", 
        "cat: B cube:/bV/rD/g@" => "up", 
        "cat: C cube:/bA/rO/g=" => "up", 
        "cat: C cube:/bV/rO/g=" => "up", 
        "cat: D cube:/bA/rO/g@" => "up", 
        "cat: D cube:/bV/rO/g@" => "up"
    }, 
    "cubeset=2/catmap=21" => {
        "cat: A cube:/bA/rD/g=" => "up", 
        "cat: A cube:/bV/rD/g=" => "up", 
        "cat: B cube:/bA/rO/g=" => "up", 
        "cat: B cube:/bV/rO/g=" => "up", 
        "cat: C cube:/bA/rD/g@" => "up", 
        "cat: C cube:/bV/rD/g@" => "up", 
        "cat: D cube:/bA/rO/g@" => "up", 
        "cat: D cube:/bV/rO/g@" => "up"
    }, 
    "cubeset=2/catmap=22" => {
        "cat: A cube:/bV/rD/g=" => "forward", 
        "cat: A cube:/bV/rD/g@" => "forward", 
        "cat: B cube:/bA/rD/g=" => "forward", 
        "cat: B cube:/bA/rD/g@" => "forward", 
        "cat: C cube:/bV/rO/g=" => "forward", 
        "cat: C cube:/bV/rO/g@" => "forward", 
        "cat: D cube:/bA/rO/g=" => "forward", 
        "cat: D cube:/bA/rO/g@" => "forward"
    }, 
    "cubeset=2/catmap=23" => {
        "cat: A cube:/bV/rD/g=" => "forward", 
        "cat: A cube:/bV/rD/g@" => "forward", 
        "cat: B cube:/bV/rO/g=" => "forward", 
        "cat: B cube:/bV/rO/g@" => "forward", 
        "cat: C cube:/bA/rD/g=" => "forward", 
        "cat: C cube:/bA/rD/g@" => "forward", 
        "cat: D cube:/bA/rO/g=" => "forward", 
        "cat: D cube:/bA/rO/g@" => "forward"
    }, 
    "cubeset=2/catmap=3" => {
        "cat: A cube:/bA/rD/g@" => "right", 
        "cat: A cube:/bA/rO/g@" => "right", 
        "cat: B cube:/bA/rD/g=" => "right", 
        "cat: B cube:/bA/rO/g=" => "right", 
        "cat: C cube:/bV/rD/g@" => "right", 
        "cat: C cube:/bV/rO/g@" => "right", 
        "cat: D cube:/bV/rD/g=" => "right", 
        "cat: D cube:/bV/rO/g=" => "right"
    }, 
    "cubeset=2/catmap=4" => {
        "cat: A cube:/bA/rO/g@" => "up", 
        "cat: A cube:/bV/rO/g@" => "up", 
        "cat: B cube:/bA/rD/g@" => "up", 
        "cat: B cube:/bV/rD/g@" => "up", 
        "cat: C cube:/bA/rO/g=" => "up", 
        "cat: C cube:/bV/rO/g=" => "up", 
        "cat: D cube:/bA/rD/g=" => "up", 
        "cat: D cube:/bV/rD/g=" => "up"
    }, 
    "cubeset=2/catmap=5" => {
        "cat: A cube:/bA/rD/g@" => "right", 
        "cat: A cube:/bA/rO/g@" => "right", 
        "cat: B cube:/bV/rD/g@" => "right", 
        "cat: B cube:/bV/rO/g@" => "right", 
        "cat: C cube:/bA/rD/g=" => "right", 
        "cat: C cube:/bA/rO/g=" => "right", 
        "cat: D cube:/bV/rD/g=" => "right", 
        "cat: D cube:/bV/rO/g=" => "right"
    }, 
    "cubeset=2/catmap=6" => {
        "cat: A cube:/bA/rO/g=" => "up", 
        "cat: A cube:/bV/rO/g=" => "up", 
        "cat: B cube:/bA/rO/g@" => "up", 
        "cat: B cube:/bV/rO/g@" => "up", 
        "cat: C cube:/bA/rD/g=" => "up", 
        "cat: C cube:/bV/rD/g=" => "up", 
        "cat: D cube:/bA/rD/g@" => "up", 
        "cat: D cube:/bV/rD/g@" => "up"
    }, 
    "cubeset=2/catmap=7" => {
        "cat: A cube:/bA/rD/g=" => "right", 
        "cat: A cube:/bA/rO/g=" => "right", 
        "cat: B cube:/bA/rD/g@" => "right", 
        "cat: B cube:/bA/rO/g@" => "right", 
        "cat: C cube:/bV/rD/g=" => "right", 
        "cat: C cube:/bV/rO/g=" => "right", 
        "cat: D cube:/bV/rD/g@" => "right", 
        "cat: D cube:/bV/rO/g@" => "right"
    }, 
    "cubeset=2/catmap=8" => {
        "cat: A cube:/bA/rO/g=" => "up", 
        "cat: A cube:/bV/rO/g=" => "up", 
        "cat: B cube:/bA/rD/g=" => "up", 
        "cat: B cube:/bV/rD/g=" => "up", 
        "cat: C cube:/bA/rO/g@" => "up", 
        "cat: C cube:/bV/rO/g@" => "up", 
        "cat: D cube:/bA/rD/g@" => "up", 
        "cat: D cube:/bV/rD/g@" => "up"
    }, 
    "cubeset=2/catmap=9" => {
        "cat: A cube:/bA/rD/g=" => "right", 
        "cat: A cube:/bA/rO/g=" => "right", 
        "cat: B cube:/bV/rD/g=" => "right", 
        "cat: B cube:/bV/rO/g=" => "right", 
        "cat: C cube:/bA/rD/g@" => "right", 
        "cat: C cube:/bA/rO/g@" => "right", 
        "cat: D cube:/bV/rD/g@" => "right", 
        "cat: D cube:/bV/rO/g@" => "right"
    }, 
    "cubeset=3/catmap=0" => {
        "cat: A cube:/g=/rO/bA" => "up", 
        "cat: A cube:/g@/rO/bA" => "up", 
        "cat: B cube:/g=/rO/bV" => "up", 
        "cat: B cube:/g@/rO/bV" => "up", 
        "cat: C cube:/g=/rD/bA" => "up", 
        "cat: C cube:/g@/rD/bA" => "up", 
        "cat: D cube:/g=/rD/bV" => "up", 
        "cat: D cube:/g@/rD/bV" => "up"
    }, 
    "cubeset=3/catmap=1" => {
        "cat: A cube:/g@/rO/bA" => "forward", 
        "cat: A cube:/g@/rO/bV" => "forward", 
        "cat: B cube:/g=/rO/bA" => "forward", 
        "cat: B cube:/g=/rO/bV" => "forward", 
        "cat: C cube:/g@/rD/bA" => "forward", 
        "cat: C cube:/g@/rD/bV" => "forward", 
        "cat: D cube:/g=/rD/bA" => "forward", 
        "cat: D cube:/g=/rD/bV" => "forward"
    }, 
    "cubeset=3/catmap=10" => {
        "cat: A cube:/g=/rO/bV" => "up", 
        "cat: A cube:/g@/rO/bV" => "up", 
        "cat: B cube:/g=/rO/bA" => "up", 
        "cat: B cube:/g@/rO/bA" => "up", 
        "cat: C cube:/g=/rD/bV" => "up", 
        "cat: C cube:/g@/rD/bV" => "up", 
        "cat: D cube:/g=/rD/bA" => "up", 
        "cat: D cube:/g@/rD/bA" => "up"
    }, 
    "cubeset=3/catmap=11" => {
        "cat: A cube:/g=/rO/bV" => "up", 
        "cat: A cube:/g@/rO/bV" => "up", 
        "cat: B cube:/g=/rD/bV" => "up", 
        "cat: B cube:/g@/rD/bV" => "up", 
        "cat: C cube:/g=/rO/bA" => "up", 
        "cat: C cube:/g@/rO/bA" => "up", 
        "cat: D cube:/g=/rD/bA" => "up", 
        "cat: D cube:/g@/rD/bA" => "up"
    }, 
    "cubeset=3/catmap=12" => {
        "cat: A cube:/g@/rD/bV" => "right", 
        "cat: A cube:/g@/rO/bV" => "right", 
        "cat: B cube:/g=/rD/bV" => "right", 
        "cat: B cube:/g=/rO/bV" => "right", 
        "cat: C cube:/g@/rD/bA" => "right", 
        "cat: C cube:/g@/rO/bA" => "right", 
        "cat: D cube:/g=/rD/bA" => "right", 
        "cat: D cube:/g=/rO/bA" => "right"
    }, 
    "cubeset=3/catmap=13" => {
        "cat: A cube:/g@/rD/bV" => "right", 
        "cat: A cube:/g@/rO/bV" => "right", 
        "cat: B cube:/g@/rD/bA" => "right", 
        "cat: B cube:/g@/rO/bA" => "right", 
        "cat: C cube:/g=/rD/bV" => "right", 
        "cat: C cube:/g=/rO/bV" => "right", 
        "cat: D cube:/g=/rD/bA" => "right", 
        "cat: D cube:/g=/rO/bA" => "right"
    }, 
    "cubeset=3/catmap=14" => {
        "cat: A cube:/g=/rD/bV" => "right", 
        "cat: A cube:/g=/rO/bV" => "right", 
        "cat: B cube:/g@/rD/bV" => "right", 
        "cat: B cube:/g@/rO/bV" => "right", 
        "cat: C cube:/g=/rD/bA" => "right", 
        "cat: C cube:/g=/rO/bA" => "right", 
        "cat: D cube:/g@/rD/bA" => "right", 
        "cat: D cube:/g@/rO/bA" => "right"
    }, 
    "cubeset=3/catmap=15" => {
        "cat: A cube:/g=/rD/bV" => "right", 
        "cat: A cube:/g=/rO/bV" => "right", 
        "cat: B cube:/g=/rD/bA" => "right", 
        "cat: B cube:/g=/rO/bA" => "right", 
        "cat: C cube:/g@/rD/bV" => "right", 
        "cat: C cube:/g@/rO/bV" => "right", 
        "cat: D cube:/g@/rD/bA" => "right", 
        "cat: D cube:/g@/rO/bA" => "right"
    }, 
    "cubeset=3/catmap=16" => {
        "cat: A cube:/g=/rD/bA" => "up", 
        "cat: A cube:/g@/rD/bA" => "up", 
        "cat: B cube:/g=/rD/bV" => "up", 
        "cat: B cube:/g@/rD/bV" => "up", 
        "cat: C cube:/g=/rO/bA" => "up", 
        "cat: C cube:/g@/rO/bA" => "up", 
        "cat: D cube:/g=/rO/bV" => "up", 
        "cat: D cube:/g@/rO/bV" => "up"
    }, 
    "cubeset=3/catmap=17" => {
        "cat: A cube:/g@/rD/bA" => "forward", 
        "cat: A cube:/g@/rD/bV" => "forward", 
        "cat: B cube:/g=/rD/bA" => "forward", 
        "cat: B cube:/g=/rD/bV" => "forward", 
        "cat: C cube:/g@/rO/bA" => "forward", 
        "cat: C cube:/g@/rO/bV" => "forward", 
        "cat: D cube:/g=/rO/bA" => "forward", 
        "cat: D cube:/g=/rO/bV" => "forward"
    }, 
    "cubeset=3/catmap=18" => {
        "cat: A cube:/g=/rD/bA" => "up", 
        "cat: A cube:/g@/rD/bA" => "up", 
        "cat: B cube:/g=/rO/bA" => "up", 
        "cat: B cube:/g@/rO/bA" => "up", 
        "cat: C cube:/g=/rD/bV" => "up", 
        "cat: C cube:/g@/rD/bV" => "up", 
        "cat: D cube:/g=/rO/bV" => "up", 
        "cat: D cube:/g@/rO/bV" => "up"
    }, 
    "cubeset=3/catmap=19" => {
        "cat: A cube:/g@/rD/bA" => "forward", 
        "cat: A cube:/g@/rD/bV" => "forward", 
        "cat: B cube:/g@/rO/bA" => "forward", 
        "cat: B cube:/g@/rO/bV" => "forward", 
        "cat: C cube:/g=/rD/bA" => "forward", 
        "cat: C cube:/g=/rD/bV" => "forward", 
        "cat: D cube:/g=/rO/bA" => "forward", 
        "cat: D cube:/g=/rO/bV" => "forward"
    }, 
    "cubeset=3/catmap=2" => {
        "cat: A cube:/g=/rO/bA" => "up", 
        "cat: A cube:/g@/rO/bA" => "up", 
        "cat: B cube:/g=/rD/bA" => "up", 
        "cat: B cube:/g@/rD/bA" => "up", 
        "cat: C cube:/g=/rO/bV" => "up", 
        "cat: C cube:/g@/rO/bV" => "up", 
        "cat: D cube:/g=/rD/bV" => "up", 
        "cat: D cube:/g@/rD/bV" => "up"
    }, 
    "cubeset=3/catmap=20" => {
        "cat: A cube:/g=/rD/bA" => "forward", 
        "cat: A cube:/g=/rD/bV" => "forward", 
        "cat: B cube:/g@/rD/bA" => "forward", 
        "cat: B cube:/g@/rD/bV" => "forward", 
        "cat: C cube:/g=/rO/bA" => "forward", 
        "cat: C cube:/g=/rO/bV" => "forward", 
        "cat: D cube:/g@/rO/bA" => "forward", 
        "cat: D cube:/g@/rO/bV" => "forward"
    }, 
    "cubeset=3/catmap=21" => {
        "cat: A cube:/g=/rD/bA" => "forward", 
        "cat: A cube:/g=/rD/bV" => "forward", 
        "cat: B cube:/g=/rO/bA" => "forward", 
        "cat: B cube:/g=/rO/bV" => "forward", 
        "cat: C cube:/g@/rD/bA" => "forward", 
        "cat: C cube:/g@/rD/bV" => "forward", 
        "cat: D cube:/g@/rO/bA" => "forward", 
        "cat: D cube:/g@/rO/bV" => "forward"
    }, 
    "cubeset=3/catmap=22" => {
        "cat: A cube:/g=/rD/bV" => "up", 
        "cat: A cube:/g@/rD/bV" => "up", 
        "cat: B cube:/g=/rD/bA" => "up", 
        "cat: B cube:/g@/rD/bA" => "up", 
        "cat: C cube:/g=/rO/bV" => "up", 
        "cat: C cube:/g@/rO/bV" => "up", 
        "cat: D cube:/g=/rO/bA" => "up", 
        "cat: D cube:/g@/rO/bA" => "up"
    }, 
    "cubeset=3/catmap=23" => {
        "cat: A cube:/g=/rD/bV" => "up", 
        "cat: A cube:/g@/rD/bV" => "up", 
        "cat: B cube:/g=/rO/bV" => "up", 
        "cat: B cube:/g@/rO/bV" => "up", 
        "cat: C cube:/g=/rD/bA" => "up", 
        "cat: C cube:/g@/rD/bA" => "up", 
        "cat: D cube:/g=/rO/bA" => "up", 
        "cat: D cube:/g@/rO/bA" => "up"
    }, 
    "cubeset=3/catmap=3" => {
        "cat: A cube:/g@/rD/bA" => "right", 
        "cat: A cube:/g@/rO/bA" => "right", 
        "cat: B cube:/g=/rD/bA" => "right", 
        "cat: B cube:/g=/rO/bA" => "right", 
        "cat: C cube:/g@/rD/bV" => "right", 
        "cat: C cube:/g@/rO/bV" => "right", 
        "cat: D cube:/g=/rD/bV" => "right", 
        "cat: D cube:/g=/rO/bV" => "right"
    }, 
    "cubeset=3/catmap=4" => {
        "cat: A cube:/g@/rO/bA" => "forward", 
        "cat: A cube:/g@/rO/bV" => "forward", 
        "cat: B cube:/g@/rD/bA" => "forward", 
        "cat: B cube:/g@/rD/bV" => "forward", 
        "cat: C cube:/g=/rO/bA" => "forward", 
        "cat: C cube:/g=/rO/bV" => "forward", 
        "cat: D cube:/g=/rD/bA" => "forward", 
        "cat: D cube:/g=/rD/bV" => "forward"
    }, 
    "cubeset=3/catmap=5" => {
        "cat: A cube:/g@/rD/bA" => "right", 
        "cat: A cube:/g@/rO/bA" => "right", 
        "cat: B cube:/g@/rD/bV" => "right", 
        "cat: B cube:/g@/rO/bV" => "right", 
        "cat: C cube:/g=/rD/bA" => "right", 
        "cat: C cube:/g=/rO/bA" => "right", 
        "cat: D cube:/g=/rD/bV" => "right", 
        "cat: D cube:/g=/rO/bV" => "right"
    }, 
    "cubeset=3/catmap=6" => {
        "cat: A cube:/g=/rO/bA" => "forward", 
        "cat: A cube:/g=/rO/bV" => "forward", 
        "cat: B cube:/g@/rO/bA" => "forward", 
        "cat: B cube:/g@/rO/bV" => "forward", 
        "cat: C cube:/g=/rD/bA" => "forward", 
        "cat: C cube:/g=/rD/bV" => "forward", 
        "cat: D cube:/g@/rD/bA" => "forward", 
        "cat: D cube:/g@/rD/bV" => "forward"
    }, 
    "cubeset=3/catmap=7" => {
        "cat: A cube:/g=/rD/bA" => "right", 
        "cat: A cube:/g=/rO/bA" => "right", 
        "cat: B cube:/g@/rD/bA" => "right", 
        "cat: B cube:/g@/rO/bA" => "right", 
        "cat: C cube:/g=/rD/bV" => "right", 
        "cat: C cube:/g=/rO/bV" => "right", 
        "cat: D cube:/g@/rD/bV" => "right", 
        "cat: D cube:/g@/rO/bV" => "right"
    }, 
    "cubeset=3/catmap=8" => {
        "cat: A cube:/g=/rO/bA" => "forward", 
        "cat: A cube:/g=/rO/bV" => "forward", 
        "cat: B cube:/g=/rD/bA" => "forward", 
        "cat: B cube:/g=/rD/bV" => "forward", 
        "cat: C cube:/g@/rO/bA" => "forward", 
        "cat: C cube:/g@/rO/bV" => "forward", 
        "cat: D cube:/g@/rD/bA" => "forward", 
        "cat: D cube:/g@/rD/bV" => "forward"
    }, 
    "cubeset=3/catmap=9" => {
        "cat: A cube:/g=/rD/bA" => "right", 
        "cat: A cube:/g=/rO/bA" => "right", 
        "cat: B cube:/g=/rD/bV" => "right", 
        "cat: B cube:/g=/rO/bV" => "right", 
        "cat: C cube:/g@/rD/bA" => "right", 
        "cat: C cube:/g@/rO/bA" => "right", 
        "cat: D cube:/g@/rD/bV" => "right", 
        "cat: D cube:/g@/rO/bV" => "right"
    }, 
    "cubeset=4/catmap=0" => {
        "cat: A cube:/bA/g=/rO" => "right", 
        "cat: A cube:/bA/g@/rO" => "right", 
        "cat: B cube:/bV/g=/rO" => "right", 
        "cat: B cube:/bV/g@/rO" => "right", 
        "cat: C cube:/bA/g=/rD" => "right", 
        "cat: C cube:/bA/g@/rD" => "right", 
        "cat: D cube:/bV/g=/rD" => "right", 
        "cat: D cube:/bV/g@/rD" => "right"
    }, 
    "cubeset=4/catmap=1" => {
        "cat: A cube:/bA/g@/rO" => "up", 
        "cat: A cube:/bV/g@/rO" => "up", 
        "cat: B cube:/bA/g=/rO" => "up", 
        "cat: B cube:/bV/g=/rO" => "up", 
        "cat: C cube:/bA/g@/rD" => "up", 
        "cat: C cube:/bV/g@/rD" => "up", 
        "cat: D cube:/bA/g=/rD" => "up", 
        "cat: D cube:/bV/g=/rD" => "up"
    }, 
    "cubeset=4/catmap=10" => {
        "cat: A cube:/bV/g=/rO" => "right", 
        "cat: A cube:/bV/g@/rO" => "right", 
        "cat: B cube:/bA/g=/rO" => "right", 
        "cat: B cube:/bA/g@/rO" => "right", 
        "cat: C cube:/bV/g=/rD" => "right", 
        "cat: C cube:/bV/g@/rD" => "right", 
        "cat: D cube:/bA/g=/rD" => "right", 
        "cat: D cube:/bA/g@/rD" => "right"
    }, 
    "cubeset=4/catmap=11" => {
        "cat: A cube:/bV/g=/rO" => "right", 
        "cat: A cube:/bV/g@/rO" => "right", 
        "cat: B cube:/bV/g=/rD" => "right", 
        "cat: B cube:/bV/g@/rD" => "right", 
        "cat: C cube:/bA/g=/rO" => "right", 
        "cat: C cube:/bA/g@/rO" => "right", 
        "cat: D cube:/bA/g=/rD" => "right", 
        "cat: D cube:/bA/g@/rD" => "right"
    }, 
    "cubeset=4/catmap=12" => {
        "cat: A cube:/bV/g@/rD" => "forward", 
        "cat: A cube:/bV/g@/rO" => "forward", 
        "cat: B cube:/bV/g=/rD" => "forward", 
        "cat: B cube:/bV/g=/rO" => "forward", 
        "cat: C cube:/bA/g@/rD" => "forward", 
        "cat: C cube:/bA/g@/rO" => "forward", 
        "cat: D cube:/bA/g=/rD" => "forward", 
        "cat: D cube:/bA/g=/rO" => "forward"
    }, 
    "cubeset=4/catmap=13" => {
        "cat: A cube:/bV/g@/rD" => "forward", 
        "cat: A cube:/bV/g@/rO" => "forward", 
        "cat: B cube:/bA/g@/rD" => "forward", 
        "cat: B cube:/bA/g@/rO" => "forward", 
        "cat: C cube:/bV/g=/rD" => "forward", 
        "cat: C cube:/bV/g=/rO" => "forward", 
        "cat: D cube:/bA/g=/rD" => "forward", 
        "cat: D cube:/bA/g=/rO" => "forward"
    }, 
    "cubeset=4/catmap=14" => {
        "cat: A cube:/bV/g=/rD" => "forward", 
        "cat: A cube:/bV/g=/rO" => "forward", 
        "cat: B cube:/bV/g@/rD" => "forward", 
        "cat: B cube:/bV/g@/rO" => "forward", 
        "cat: C cube:/bA/g=/rD" => "forward", 
        "cat: C cube:/bA/g=/rO" => "forward", 
        "cat: D cube:/bA/g@/rD" => "forward", 
        "cat: D cube:/bA/g@/rO" => "forward"
    }, 
    "cubeset=4/catmap=15" => {
        "cat: A cube:/bV/g=/rD" => "forward", 
        "cat: A cube:/bV/g=/rO" => "forward", 
        "cat: B cube:/bA/g=/rD" => "forward", 
        "cat: B cube:/bA/g=/rO" => "forward", 
        "cat: C cube:/bV/g@/rD" => "forward", 
        "cat: C cube:/bV/g@/rO" => "forward", 
        "cat: D cube:/bA/g@/rD" => "forward", 
        "cat: D cube:/bA/g@/rO" => "forward"
    }, 
    "cubeset=4/catmap=16" => {
        "cat: A cube:/bA/g=/rD" => "right", 
        "cat: A cube:/bA/g@/rD" => "right", 
        "cat: B cube:/bV/g=/rD" => "right", 
        "cat: B cube:/bV/g@/rD" => "right", 
        "cat: C cube:/bA/g=/rO" => "right", 
        "cat: C cube:/bA/g@/rO" => "right", 
        "cat: D cube:/bV/g=/rO" => "right", 
        "cat: D cube:/bV/g@/rO" => "right"
    }, 
    "cubeset=4/catmap=17" => {
        "cat: A cube:/bA/g@/rD" => "up", 
        "cat: A cube:/bV/g@/rD" => "up", 
        "cat: B cube:/bA/g=/rD" => "up", 
        "cat: B cube:/bV/g=/rD" => "up", 
        "cat: C cube:/bA/g@/rO" => "up", 
        "cat: C cube:/bV/g@/rO" => "up", 
        "cat: D cube:/bA/g=/rO" => "up", 
        "cat: D cube:/bV/g=/rO" => "up"
    }, 
    "cubeset=4/catmap=18" => {
        "cat: A cube:/bA/g=/rD" => "right", 
        "cat: A cube:/bA/g@/rD" => "right", 
        "cat: B cube:/bA/g=/rO" => "right", 
        "cat: B cube:/bA/g@/rO" => "right", 
        "cat: C cube:/bV/g=/rD" => "right", 
        "cat: C cube:/bV/g@/rD" => "right", 
        "cat: D cube:/bV/g=/rO" => "right", 
        "cat: D cube:/bV/g@/rO" => "right"
    }, 
    "cubeset=4/catmap=19" => {
        "cat: A cube:/bA/g@/rD" => "up", 
        "cat: A cube:/bV/g@/rD" => "up", 
        "cat: B cube:/bA/g@/rO" => "up", 
        "cat: B cube:/bV/g@/rO" => "up", 
        "cat: C cube:/bA/g=/rD" => "up", 
        "cat: C cube:/bV/g=/rD" => "up", 
        "cat: D cube:/bA/g=/rO" => "up", 
        "cat: D cube:/bV/g=/rO" => "up"
    }, 
    "cubeset=4/catmap=2" => {
        "cat: A cube:/bA/g=/rO" => "right", 
        "cat: A cube:/bA/g@/rO" => "right", 
        "cat: B cube:/bA/g=/rD" => "right", 
        "cat: B cube:/bA/g@/rD" => "right", 
        "cat: C cube:/bV/g=/rO" => "right", 
        "cat: C cube:/bV/g@/rO" => "right", 
        "cat: D cube:/bV/g=/rD" => "right", 
        "cat: D cube:/bV/g@/rD" => "right"
    }, 
    "cubeset=4/catmap=20" => {
        "cat: A cube:/bA/g=/rD" => "up", 
        "cat: A cube:/bV/g=/rD" => "up", 
        "cat: B cube:/bA/g@/rD" => "up", 
        "cat: B cube:/bV/g@/rD" => "up", 
        "cat: C cube:/bA/g=/rO" => "up", 
        "cat: C cube:/bV/g=/rO" => "up", 
        "cat: D cube:/bA/g@/rO" => "up", 
        "cat: D cube:/bV/g@/rO" => "up"
    }, 
    "cubeset=4/catmap=21" => {
        "cat: A cube:/bA/g=/rD" => "up", 
        "cat: A cube:/bV/g=/rD" => "up", 
        "cat: B cube:/bA/g=/rO" => "up", 
        "cat: B cube:/bV/g=/rO" => "up", 
        "cat: C cube:/bA/g@/rD" => "up", 
        "cat: C cube:/bV/g@/rD" => "up", 
        "cat: D cube:/bA/g@/rO" => "up", 
        "cat: D cube:/bV/g@/rO" => "up"
    }, 
    "cubeset=4/catmap=22" => {
        "cat: A cube:/bV/g=/rD" => "right", 
        "cat: A cube:/bV/g@/rD" => "right", 
        "cat: B cube:/bA/g=/rD" => "right", 
        "cat: B cube:/bA/g@/rD" => "right", 
        "cat: C cube:/bV/g=/rO" => "right", 
        "cat: C cube:/bV/g@/rO" => "right", 
        "cat: D cube:/bA/g=/rO" => "right", 
        "cat: D cube:/bA/g@/rO" => "right"
    }, 
    "cubeset=4/catmap=23" => {
        "cat: A cube:/bV/g=/rD" => "right", 
        "cat: A cube:/bV/g@/rD" => "right", 
        "cat: B cube:/bV/g=/rO" => "right", 
        "cat: B cube:/bV/g@/rO" => "right", 
        "cat: C cube:/bA/g=/rD" => "right", 
        "cat: C cube:/bA/g@/rD" => "right", 
        "cat: D cube:/bA/g=/rO" => "right", 
        "cat: D cube:/bA/g@/rO" => "right"
    }, 
    "cubeset=4/catmap=3" => {
        "cat: A cube:/bA/g@/rD" => "forward", 
        "cat: A cube:/bA/g@/rO" => "forward", 
        "cat: B cube:/bA/g=/rD" => "forward", 
        "cat: B cube:/bA/g=/rO" => "forward", 
        "cat: C cube:/bV/g@/rD" => "forward", 
        "cat: C cube:/bV/g@/rO" => "forward", 
        "cat: D cube:/bV/g=/rD" => "forward", 
        "cat: D cube:/bV/g=/rO" => "forward"
    }, 
    "cubeset=4/catmap=4" => {
        "cat: A cube:/bA/g@/rO" => "up", 
        "cat: A cube:/bV/g@/rO" => "up", 
        "cat: B cube:/bA/g@/rD" => "up", 
        "cat: B cube:/bV/g@/rD" => "up", 
        "cat: C cube:/bA/g=/rO" => "up", 
        "cat: C cube:/bV/g=/rO" => "up", 
        "cat: D cube:/bA/g=/rD" => "up", 
        "cat: D cube:/bV/g=/rD" => "up"
    }, 
    "cubeset=4/catmap=5" => {
        "cat: A cube:/bA/g@/rD" => "forward", 
        "cat: A cube:/bA/g@/rO" => "forward", 
        "cat: B cube:/bV/g@/rD" => "forward", 
        "cat: B cube:/bV/g@/rO" => "forward", 
        "cat: C cube:/bA/g=/rD" => "forward", 
        "cat: C cube:/bA/g=/rO" => "forward", 
        "cat: D cube:/bV/g=/rD" => "forward", 
        "cat: D cube:/bV/g=/rO" => "forward"
    }, 
    "cubeset=4/catmap=6" => {
        "cat: A cube:/bA/g=/rO" => "up", 
        "cat: A cube:/bV/g=/rO" => "up", 
        "cat: B cube:/bA/g@/rO" => "up", 
        "cat: B cube:/bV/g@/rO" => "up", 
        "cat: C cube:/bA/g=/rD" => "up", 
        "cat: C cube:/bV/g=/rD" => "up", 
        "cat: D cube:/bA/g@/rD" => "up", 
        "cat: D cube:/bV/g@/rD" => "up"
    }, 
    "cubeset=4/catmap=7" => {
        "cat: A cube:/bA/g=/rD" => "forward", 
        "cat: A cube:/bA/g=/rO" => "forward", 
        "cat: B cube:/bA/g@/rD" => "forward", 
        "cat: B cube:/bA/g@/rO" => "forward", 
        "cat: C cube:/bV/g=/rD" => "forward", 
        "cat: C cube:/bV/g=/rO" => "forward", 
        "cat: D cube:/bV/g@/rD" => "forward", 
        "cat: D cube:/bV/g@/rO" => "forward"
    }, 
    "cubeset=4/catmap=8" => {
        "cat: A cube:/bA/g=/rO" => "up", 
        "cat: A cube:/bV/g=/rO" => "up", 
        "cat: B cube:/bA/g=/rD" => "up", 
        "cat: B cube:/bV/g=/rD" => "up", 
        "cat: C cube:/bA/g@/rO" => "up", 
        "cat: C cube:/bV/g@/rO" => "up", 
        "cat: D cube:/bA/g@/rD" => "up", 
        "cat: D cube:/bV/g@/rD" => "up"
    }, 
    "cubeset=4/catmap=9" => {
        "cat: A cube:/bA/g=/rD" => "forward", 
        "cat: A cube:/bA/g=/rO" => "forward", 
        "cat: B cube:/bV/g=/rD" => "forward", 
        "cat: B cube:/bV/g=/rO" => "forward", 
        "cat: C cube:/bA/g@/rD" => "forward", 
        "cat: C cube:/bA/g@/rO" => "forward", 
        "cat: D cube:/bV/g@/rD" => "forward", 
        "cat: D cube:/bV/g@/rO" => "forward"
    }, 
    "cubeset=5/catmap=0" => {
        "cat: A cube:/g=/bA/rO" => "up", 
        "cat: A cube:/g@/bA/rO" => "up", 
        "cat: B cube:/g=/bV/rO" => "up", 
        "cat: B cube:/g@/bV/rO" => "up", 
        "cat: C cube:/g=/bA/rD" => "up", 
        "cat: C cube:/g@/bA/rD" => "up", 
        "cat: D cube:/g=/bV/rD" => "up", 
        "cat: D cube:/g@/bV/rD" => "up"
    }, 
    "cubeset=5/catmap=1" => {
        "cat: A cube:/g@/bA/rO" => "right", 
        "cat: A cube:/g@/bV/rO" => "right", 
        "cat: B cube:/g=/bA/rO" => "right", 
        "cat: B cube:/g=/bV/rO" => "right", 
        "cat: C cube:/g@/bA/rD" => "right", 
        "cat: C cube:/g@/bV/rD" => "right", 
        "cat: D cube:/g=/bA/rD" => "right", 
        "cat: D cube:/g=/bV/rD" => "right"
    }, 
    "cubeset=5/catmap=10" => {
        "cat: A cube:/g=/bV/rO" => "up", 
        "cat: A cube:/g@/bV/rO" => "up", 
        "cat: B cube:/g=/bA/rO" => "up", 
        "cat: B cube:/g@/bA/rO" => "up", 
        "cat: C cube:/g=/bV/rD" => "up", 
        "cat: C cube:/g@/bV/rD" => "up", 
        "cat: D cube:/g=/bA/rD" => "up", 
        "cat: D cube:/g@/bA/rD" => "up"
    }, 
    "cubeset=5/catmap=11" => {
        "cat: A cube:/g=/bV/rO" => "up", 
        "cat: A cube:/g@/bV/rO" => "up", 
        "cat: B cube:/g=/bV/rD" => "up", 
        "cat: B cube:/g@/bV/rD" => "up", 
        "cat: C cube:/g=/bA/rO" => "up", 
        "cat: C cube:/g@/bA/rO" => "up", 
        "cat: D cube:/g=/bA/rD" => "up", 
        "cat: D cube:/g@/bA/rD" => "up"
    }, 
    "cubeset=5/catmap=12" => {
        "cat: A cube:/g@/bV/rD" => "forward", 
        "cat: A cube:/g@/bV/rO" => "forward", 
        "cat: B cube:/g=/bV/rD" => "forward", 
        "cat: B cube:/g=/bV/rO" => "forward", 
        "cat: C cube:/g@/bA/rD" => "forward", 
        "cat: C cube:/g@/bA/rO" => "forward", 
        "cat: D cube:/g=/bA/rD" => "forward", 
        "cat: D cube:/g=/bA/rO" => "forward"
    }, 
    "cubeset=5/catmap=13" => {
        "cat: A cube:/g@/bV/rD" => "forward", 
        "cat: A cube:/g@/bV/rO" => "forward", 
        "cat: B cube:/g@/bA/rD" => "forward", 
        "cat: B cube:/g@/bA/rO" => "forward", 
        "cat: C cube:/g=/bV/rD" => "forward", 
        "cat: C cube:/g=/bV/rO" => "forward", 
        "cat: D cube:/g=/bA/rD" => "forward", 
        "cat: D cube:/g=/bA/rO" => "forward"
    }, 
    "cubeset=5/catmap=14" => {
        "cat: A cube:/g=/bV/rD" => "forward", 
        "cat: A cube:/g=/bV/rO" => "forward", 
        "cat: B cube:/g@/bV/rD" => "forward", 
        "cat: B cube:/g@/bV/rO" => "forward", 
        "cat: C cube:/g=/bA/rD" => "forward", 
        "cat: C cube:/g=/bA/rO" => "forward", 
        "cat: D cube:/g@/bA/rD" => "forward", 
        "cat: D cube:/g@/bA/rO" => "forward"
    }, 
    "cubeset=5/catmap=15" => {
        "cat: A cube:/g=/bV/rD" => "forward", 
        "cat: A cube:/g=/bV/rO" => "forward", 
        "cat: B cube:/g=/bA/rD" => "forward", 
        "cat: B cube:/g=/bA/rO" => "forward", 
        "cat: C cube:/g@/bV/rD" => "forward", 
        "cat: C cube:/g@/bV/rO" => "forward", 
        "cat: D cube:/g@/bA/rD" => "forward", 
        "cat: D cube:/g@/bA/rO" => "forward"
    }, 
    "cubeset=5/catmap=16" => {
        "cat: A cube:/g=/bA/rD" => "up", 
        "cat: A cube:/g@/bA/rD" => "up", 
        "cat: B cube:/g=/bV/rD" => "up", 
        "cat: B cube:/g@/bV/rD" => "up", 
        "cat: C cube:/g=/bA/rO" => "up", 
        "cat: C cube:/g@/bA/rO" => "up", 
        "cat: D cube:/g=/bV/rO" => "up", 
        "cat: D cube:/g@/bV/rO" => "up"
    }, 
    "cubeset=5/catmap=17" => {
        "cat: A cube:/g@/bA/rD" => "right", 
        "cat: A cube:/g@/bV/rD" => "right", 
        "cat: B cube:/g=/bA/rD" => "right", 
        "cat: B cube:/g=/bV/rD" => "right", 
        "cat: C cube:/g@/bA/rO" => "right", 
        "cat: C cube:/g@/bV/rO" => "right", 
        "cat: D cube:/g=/bA/rO" => "right", 
        "cat: D cube:/g=/bV/rO" => "right"
    }, 
    "cubeset=5/catmap=18" => {
        "cat: A cube:/g=/bA/rD" => "up", 
        "cat: A cube:/g@/bA/rD" => "up", 
        "cat: B cube:/g=/bA/rO" => "up", 
        "cat: B cube:/g@/bA/rO" => "up", 
        "cat: C cube:/g=/bV/rD" => "up", 
        "cat: C cube:/g@/bV/rD" => "up", 
        "cat: D cube:/g=/bV/rO" => "up", 
        "cat: D cube:/g@/bV/rO" => "up"
    }, 
    "cubeset=5/catmap=19" => {
        "cat: A cube:/g@/bA/rD" => "right", 
        "cat: A cube:/g@/bV/rD" => "right", 
        "cat: B cube:/g@/bA/rO" => "right", 
        "cat: B cube:/g@/bV/rO" => "right", 
        "cat: C cube:/g=/bA/rD" => "right", 
        "cat: C cube:/g=/bV/rD" => "right", 
        "cat: D cube:/g=/bA/rO" => "right", 
        "cat: D cube:/g=/bV/rO" => "right"
    }, 
    "cubeset=5/catmap=2" => {
        "cat: A cube:/g=/bA/rO" => "up", 
        "cat: A cube:/g@/bA/rO" => "up", 
        "cat: B cube:/g=/bA/rD" => "up", 
        "cat: B cube:/g@/bA/rD" => "up", 
        "cat: C cube:/g=/bV/rO" => "up", 
        "cat: C cube:/g@/bV/rO" => "up", 
        "cat: D cube:/g=/bV/rD" => "up", 
        "cat: D cube:/g@/bV/rD" => "up"
    }, 
    "cubeset=5/catmap=20" => {
        "cat: A cube:/g=/bA/rD" => "right", 
        "cat: A cube:/g=/bV/rD" => "right", 
        "cat: B cube:/g@/bA/rD" => "right", 
        "cat: B cube:/g@/bV/rD" => "right", 
        "cat: C cube:/g=/bA/rO" => "right", 
        "cat: C cube:/g=/bV/rO" => "right", 
        "cat: D cube:/g@/bA/rO" => "right", 
        "cat: D cube:/g@/bV/rO" => "right"
    }, 
    "cubeset=5/catmap=21" => {
        "cat: A cube:/g=/bA/rD" => "right", 
        "cat: A cube:/g=/bV/rD" => "right", 
        "cat: B cube:/g=/bA/rO" => "right", 
        "cat: B cube:/g=/bV/rO" => "right", 
        "cat: C cube:/g@/bA/rD" => "right", 
        "cat: C cube:/g@/bV/rD" => "right", 
        "cat: D cube:/g@/bA/rO" => "right", 
        "cat: D cube:/g@/bV/rO" => "right"
    }, 
    "cubeset=5/catmap=22" => {
        "cat: A cube:/g=/bV/rD" => "up", 
        "cat: A cube:/g@/bV/rD" => "up", 
        "cat: B cube:/g=/bA/rD" => "up", 
        "cat: B cube:/g@/bA/rD" => "up", 
        "cat: C cube:/g=/bV/rO" => "up", 
        "cat: C cube:/g@/bV/rO" => "up", 
        "cat: D cube:/g=/bA/rO" => "up", 
        "cat: D cube:/g@/bA/rO" => "up"
    }, 
    "cubeset=5/catmap=23" => {
        "cat: A cube:/g=/bV/rD" => "up", 
        "cat: A cube:/g@/bV/rD" => "up", 
        "cat: B cube:/g=/bV/rO" => "up", 
        "cat: B cube:/g@/bV/rO" => "up", 
        "cat: C cube:/g=/bA/rD" => "up", 
        "cat: C cube:/g@/bA/rD" => "up", 
        "cat: D cube:/g=/bA/rO" => "up", 
        "cat: D cube:/g@/bA/rO" => "up"
    }, 
    "cubeset=5/catmap=3" => {
        "cat: A cube:/g@/bA/rD" => "forward", 
        "cat: A cube:/g@/bA/rO" => "forward", 
        "cat: B cube:/g=/bA/rD" => "forward", 
        "cat: B cube:/g=/bA/rO" => "forward", 
        "cat: C cube:/g@/bV/rD" => "forward", 
        "cat: C cube:/g@/bV/rO" => "forward", 
        "cat: D cube:/g=/bV/rD" => "forward", 
        "cat: D cube:/g=/bV/rO" => "forward"
    }, 
    "cubeset=5/catmap=4" => {
        "cat: A cube:/g@/bA/rO" => "right", 
        "cat: A cube:/g@/bV/rO" => "right", 
        "cat: B cube:/g@/bA/rD" => "right", 
        "cat: B cube:/g@/bV/rD" => "right", 
        "cat: C cube:/g=/bA/rO" => "right", 
        "cat: C cube:/g=/bV/rO" => "right", 
        "cat: D cube:/g=/bA/rD" => "right", 
        "cat: D cube:/g=/bV/rD" => "right"
    }, 
    "cubeset=5/catmap=5" => {
        "cat: A cube:/g@/bA/rD" => "forward", 
        "cat: A cube:/g@/bA/rO" => "forward", 
        "cat: B cube:/g@/bV/rD" => "forward", 
        "cat: B cube:/g@/bV/rO" => "forward", 
        "cat: C cube:/g=/bA/rD" => "forward", 
        "cat: C cube:/g=/bA/rO" => "forward", 
        "cat: D cube:/g=/bV/rD" => "forward", 
        "cat: D cube:/g=/bV/rO" => "forward"
    }, 
    "cubeset=5/catmap=6" => {
        "cat: A cube:/g=/bA/rO" => "right", 
        "cat: A cube:/g=/bV/rO" => "right", 
        "cat: B cube:/g@/bA/rO" => "right", 
        "cat: B cube:/g@/bV/rO" => "right", 
        "cat: C cube:/g=/bA/rD" => "right", 
        "cat: C cube:/g=/bV/rD" => "right", 
        "cat: D cube:/g@/bA/rD" => "right", 
        "cat: D cube:/g@/bV/rD" => "right"
    }, 
    "cubeset=5/catmap=7" => {
        "cat: A cube:/g=/bA/rD" => "forward", 
        "cat: A cube:/g=/bA/rO" => "forward", 
        "cat: B cube:/g@/bA/rD" => "forward", 
        "cat: B cube:/g@/bA/rO" => "forward", 
        "cat: C cube:/g=/bV/rD" => "forward", 
        "cat: C cube:/g=/bV/rO" => "forward", 
        "cat: D cube:/g@/bV/rD" => "forward", 
        "cat: D cube:/g@/bV/rO" => "forward"
    }, 
    "cubeset=5/catmap=8" => {
        "cat: A cube:/g=/bA/rO" => "right", 
        "cat: A cube:/g=/bV/rO" => "right", 
        "cat: B cube:/g=/bA/rD" => "right", 
        "cat: B cube:/g=/bV/rD" => "right", 
        "cat: C cube:/g@/bA/rO" => "right", 
        "cat: C cube:/g@/bV/rO" => "right", 
        "cat: D cube:/g@/bA/rD" => "right", 
        "cat: D cube:/g@/bV/rD" => "right"
    }, 
    "cubeset=5/catmap=9" => {
        "cat: A cube:/g=/bA/rD" => "forward", 
        "cat: A cube:/g=/bA/rO" => "forward", 
        "cat: B cube:/g=/bV/rD" => "forward", 
        "cat: B cube:/g=/bV/rO" => "forward", 
        "cat: C cube:/g@/bA/rD" => "forward", 
        "cat: C cube:/g@/bA/rO" => "forward", 
        "cat: D cube:/g@/bV/rD" => "forward", 
        "cat: D cube:/g@/bV/rO" => "forward"
    }
);

sub getIrrelevant {
	my ($cscm, $cube) = @_;
	die "can't find $cscm" unless defined $irrelevant{$cscm};
	my @s = (%{$irrelevant{$cscm}});
	my $s = @s[0];
	$s =~ m#cat: . cube:/(.)./(.)./(.).#;
	@rgb = ($1,$2,$3);
	die "invalid cube $cube" unless 
		$cube =~ m#(cat: . cube:)/((.).)/((.).)/((.).)#;
	%orgb = ($3=>$2, $5=>$4, $7=>$6);
	$ncube = $1;
	foreach $c (@rgb) {
		$ncube .= "/$orgb{$c}";
	}
	die "$cscm $ncube: not found " unless defined $irrelevant{$cscm}{$ncube};
	return $irrelevant{$cscm}{$ncube};
}

sub isRelevant {
	my ($cscm, $cube, $oirr) = @_;
	my $irr = getIrrelevant($cscm, $cube);
	# print STDERR "$cscm $cube irrelevant $irr checked against $oirr\n";
	return $irr eq $oirr ? 0 : 1;
}
1;

