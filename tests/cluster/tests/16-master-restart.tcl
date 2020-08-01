# Confirm that master restarting within node timeout does not flush
# shard.

source "../tests/includes/init-tests.tcl"

test "Create a 3 node cluster" {
    create_cluster 3 3
}

test "Cluster should start ok" {
    assert_cluster_state ok
}

test "Write some data to the cluster." {
    cluster_write_test_prefix 0 master-restart
}

test "Killing one master node" {
    kill_instance redis 0
}

test "Restarting master node" {
    restart_instance redis 0
}

test "Cluster should be still up" {
    assert_cluster_state ok
}

test "Node 0 should still be master" {
    assert {[RI 0 role] eq {master}}
}

test "No data should be missing" {
    cluster_read_test_prefix 0 master-restart
}
