#include "/home/cdodd/p4c/build/../p4include/core.p4"
#include "/home/cdodd/p4c/build/../p4include/v1model.p4"

header data_t {
    bit<32> f1;
    bit<32> f2;
    bit<32> f3;
    bit<32> f4;
    bit<8>  b1;
    bit<8>  b2;
    bit<8>  b3;
    bit<8>  b4;
}

struct metadata {
}

struct headers {
    @name("data") 
    data_t data;
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("start") state start {
        packet.extract(hdr.data);
        transition accept;
    }
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("do_add") action do_add() {
        bool hasReturned_1 = false;
        hdr.data.b3 = hdr.data.b1 + hdr.data.b2;
    }
    @name("do_and") action do_and() {
        bool hasReturned_2 = false;
        hdr.data.b2 = hdr.data.b3 & hdr.data.b4;
    }
    @name("do_or") action do_or() {
        bool hasReturned_3 = false;
        hdr.data.b4 = hdr.data.b3 | hdr.data.b1;
    }
    @name("do_xor") action do_xor() {
        bool hasReturned_4 = false;
        hdr.data.b1 = hdr.data.b2 ^ hdr.data.b3;
    }
    @name("test1") table test1() {
        actions = {
            do_add;
            do_and;
            do_or;
            do_xor;
            NoAction;
        }
        key = {
            hdr.data.f1: exact;
        }
        default_action = NoAction();
    }

    apply {
        bool hasReturned_0 = false;
        test1.apply();
    }
}

control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
        bool hasReturned_5 = false;
    }
}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        bool hasReturned_6 = false;
        packet.emit(hdr.data);
    }
}

control verifyChecksum(in headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
        bool hasReturned_7 = false;
    }
}

control computeChecksum(inout headers hdr, inout metadata meta) {
    apply {
        bool hasReturned_8 = false;
    }
}

V1Switch(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;
