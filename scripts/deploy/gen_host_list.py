import argparse
import math

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate replica and client files for a run.')
    parser.add_argument('--ip_list', type=str, default='ip_list.txt',
                        help='text file with all available IPs (each row is "<external_ip> <inter_replica_net_ip>")')
    parser.add_argument('--replicas', type=str, default='replicas.txt',
                        help='text file with all replicas IPs (each row is "<external_ip> <inter_replica_net_ip>", repeat a line if you would like to share the same machine)')
    parser.add_argument('--clients', type=str, default='clients.txt',
                        help='text file with all clients IPs (each row is "<external_ip>")')
    parser.add_argument('--num_replica', type=int, default=4,
                        help='number of replica to be read from the ip_list.txt')
    parser.add_argument('--num_clients', type=int, default=4,
                        help='number of clients to be read from the ip_list.txt')
    args = parser.parse_args()

    replica_ip = []
    client_ip = []
    ipfile = open(args.ip_list, "r")
    rfile = open(args.replicas, "w")
    cfile = open(args.clients, "w")
    line_ind = 0
    for line in ipfile:
        (pub_ip, priv_ip) = line.split()
        if line_ind < args.num_replica:
            replica_ip.append((pub_ip.strip(), priv_ip.strip()))
        else:
            client_ip.append(pub_ip.strip())
        line_ind += 1
    for (i, (pub_ip, priv_ip)) in enumerate(replica_ip):
        rfile.write("{} {}\n".format(pub_ip,priv_ip)) 
    rounds = math.ceil(args.num_clients/len(client_ip))
    cli = 0
    for r in range(rounds):
        for (i, (pub_ip)) in enumerate(client_ip):
            cfile.write("{}\n".format(pub_ip))
            cli += 1
            if cli == args.num_clients:
                break
