proxmox-init:
	./build/scripts/run.sh ansible-playbook /etc/ansible/playbooks/role_playbooks/proxmox/init.yml

proxmox-templates:
	./build/scripts/run.sh ansible-playbook /etc/ansible/playbooks/role_playbooks/proxmox/templates.yml

proxmox-realtek:
	./build/scripts/run.sh ansible-playbook /etc/ansible/playbooks/role_playbooks/realtek.yml

test:
	./build/scripts/run.sh ansible-playbook /etc/ansible/playbooks/ping.yml

new-role: #make role="iscsi-multipath" new-role
	./build/scripts/run.sh ansible-galaxy init /etc/ansible/roles/$(role)

install-roles:
	./build/scripts/run.sh ansible-galaxy install -r /etc/ansible/requirements.yaml