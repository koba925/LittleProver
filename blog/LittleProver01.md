# 定理証明手習い (1) はじめに、とか

定理証明手習い https://www.lambdanote.com/collections/littleprover ゆっくり読んでいきます

Litter Schemerシリーズは何冊もあって全貌はよくわかってないんですが
知ってる範囲では以下の４冊があります

* The Little Schemer (Scheme手習い)
* The Seasoned Schemer (Scheme修行)
* The Reasoned Schemer (たぶん未訳)
* The Little Prover (定理証明手習い)

ナントカSchemerってやつはDaniel FriedmanとMatthias Felleisenの共著ですが
Little ProverはFelleisenとCarl Eastlundの共著となっています
Carl Eastlundはどういうひとかわかりませんが自動証明の研究をしている人らしいです

Seasoned Schemerまでは読んだので次はReasoned Schemerかなあ、
しかたないから英語で読むか、と思っていたんですが
ここでLitter Proverの和訳が出たのでじゃあそっちから、てな感じです
Reasoned Schemerまでやったらコンプリート気分なのでいつかやります

では序文、はじめに、あとがきあたりから
ここからネタバレです

> 本書の目標は、帰納法を使うことで再帰的な関数についての事実を明らかにする方法を
> 読者に知ってもらうことです。

Little Schemerで再帰を覚えて、Little Proverでそれを証明する方法を覚えると

前にも書きましたけど、この本は訳者の名前は出てこなくて監訳者の中野圭介さんの
名前だけが表紙に書いてあります
ちょっとめずらしいパターンかなという気がしますがその監訳者さんの序文によると
この本はプログラムの正しさを証明するための入門書、といいます

プログラムの正しさってなんでしょうか
仕様どおりに動くってことですかね
現実世界ではそもそも仕様がキッチリ決まっていることがなかったりしますが

定理を表す主張に対して等価な式変形を繰り返して定理を証明するそうです
定理の証明はJ-Bobというツールがサポートしてくれるらしい
J-BobをマスターしたらACL2に進むのもよいし
Coq、Agda、Isabelle/HOLといった証明支援系に挑戦してみるのもよいとのこと
Coqだけ聞いたことありますが他はちょっと
Coqも名前しか聞いたことないですけど

序文はJ Strother Mooreさん
定理証明器を研究してきた人でACL2の作成者のひとり
その研究でACMの賞を取ってるくらいなので分野の大御所的な人でしょうか
上に出てきたJ-BobのJはこの人の名前からとったものだそうです

> 関数やプログラムの振る舞いを記述するための数理論理学とはどのようなものだろうか？
> 「定理」とは何であろうか？定理をどうやって「証明」するのだろうか？
> 「自動定理証明器」とは何か？

たまたまですがゲーデルとつながってる感じ

あと言語について軽い説明があります
`atom`とか`defun`とかCommon Lispの流れみたいですね
ACL2のページを見てみたら

> "ACL2" denotes "A Computational Logic for Applicative Common Lisp".

って書いてありました
Applicativeってついてますがでも何かCommon Lispなんでしょう

`size`は値を組み立てるのに必要な`cons`の数
単純にリストの長さってことじゃないんだ

定理は`dethm`で定義します
`defun`と違って定理を再帰的に定義することはできません

ところで

> `atom`は、空でないリストに対しては`'t`を、そうでなければ`'nil`を返します。

これ反対じゃないかなあ

あとがきはMatthias Felleisenさん
ちょっとメイキングみたいな話が出てます
なるほど
