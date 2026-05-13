extends Node2D

## Spirit Vein Network - manages spirit energy flow between nodes
## Players connect nodes to build a spirit energy network powering formations

class VeinNode:
	var grid_pos: Vector2i
	var energy_output: float = 1.0
	var energy_stored: float = 0.0
	var max_energy: float = 10.0
	var connections: Array[Vector2i] = []
	var is_active: bool = true


class VeinLink:
	var node_a: Vector2i
	var node_b: Vector2i
	var throughput: float = 5.0
	var current_flow: float = 0.0


var _nodes: Dictionary = {}  # Vector2i -> VeinNode
var _links: Array[VeinLink] = []
var total_energy: float = 100.0
var max_total_energy: float = 200.0


func add_node(pos: Vector2i, output: float = 1.0) -> void:
	if _nodes.has(pos):
		return
	var node := VeinNode.new()
	node.grid_pos = pos
	node.energy_output = output
	_nodes[pos] = node
	EventBus.spirit_energy_changed.emit(total_energy)


func remove_node(pos: Vector2i) -> void:
	if not _nodes.has(pos):
		return
	# Remove all links to this node
	var to_remove: Array[VeinLink] = []
	for link: VeinLink in _links:
		if link.node_a == pos or link.node_b == pos:
			to_remove.append(link)
	for link: VeinLink in to_remove:
		_links.erase(link)
		EventBus.vein_disconnected.emit(link.node_a, link.node_b)
	_nodes.erase(pos)


func connect_nodes(a: Vector2i, b: Vector2i) -> bool:
	if not _nodes.has(a) or not _nodes.has(b):
		return false
	for link: VeinLink in _links:
		if (link.node_a == a and link.node_b == b) or (link.node_a == b and link.node_b == a):
			return false
	var link := VeinLink.new()
	link.node_a = a
	link.node_b = b
	_links.append(link)
	EventBus.vein_connected.emit(a, b)
	return true


func disconnect_nodes(a: Vector2i, b: Vector2i) -> void:
	for i: int in range(_links.size() - 1, -1, -1):
		var link: VeinLink = _links[i]
		if (link.node_a == a and link.node_b == b) or (link.node_a == b and link.node_b == a):
			_links.remove_at(i)
			EventBus.vein_disconnected.emit(a, b)
			return


func _process(delta: float) -> void:
	# Regenerate energy from active nodes
	for pos: Vector2i in _nodes:
		var node: VeinNode = _nodes[pos]
		if node.is_active:
			total_energy += node.energy_output * delta
	total_energy = minf(total_energy, max_total_energy)
	# Flow energy through links
	for link: VeinLink in _links:
		if not _nodes.has(link.node_a) or not _nodes.has(link.node_b):
			continue
		var node_a: VeinNode = _nodes[link.node_a]
		var node_b: VeinNode = _nodes[link.node_b]
		var diff: float = node_a.energy_stored - node_b.energy_stored
		link.current_flow = clampf(diff * 0.5, -link.throughput, link.throughput)
		node_a.energy_stored -= link.current_flow * delta
		node_b.energy_stored += link.current_flow * delta
