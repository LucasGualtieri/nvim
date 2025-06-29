import java.util.HashMap;

public class teste {

	private static class Pessoa {

		private String nome;

		public Pessoa(String nome) {
			this.nome = nome;
		}

		@Override
		public String toString() {
		    return nome;
		}

		@SuppressWarnings("unused")
		public void setNome(String nome) {
		    this.nome = nome;
		}

		@SuppressWarnings("unused")
		public String getNome() {
		    return nome;
		}
	}

	public static void main(String[] args) {

		System.out.println(foo("Hello world!"));

		HashMap<Pessoa, Integer> map = new HashMap<>();

		int n = 100_000;

		for (int i = 0; i < n; i++) {

			Pessoa p  = new Pessoa(String.format("Pessoa%d", i));
			// System.out.println(p);
			map.put(p, i);

			// System.out.println(map.get(p));
			map.get(p);
		}
	}

	private static String foo(String msg) {
		return msg;
	}
}
