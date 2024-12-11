-- Additional exercises
INSERT INTO exercises (
    id, video_id, name, preparation, execution, goal, tips,
    muscle_group, category, is_sitting, is_theraband, is_dynamic, is_one_sided
) VALUES
-- Additional Shoulder Exercises
(2, '8QnjAqC-Px0', 'Mobilisation Schultergürtel 2 - sitzend',
    'Setzen Sie sich aufrecht auf den vorderen Teil ihres Stuhls. Die Arme hängen locker herab',
    'Führen Sie die rechte Schulter hoch und gleichzeitig die linke herunter. Heben Sie anschließend beide Schultern an und lassen sie wieder fallen',
    'Mobilisation des Schultergürtels',
    NULL,
    'Schulter', 'Mobilisation', TRUE, FALSE, TRUE, FALSE),

(3, '2g-Q_tBrAeE', 'Mobilisation Schultergürtel 3 - sitzend',
    'Setzen Sie sich aufrecht auf den vorderen Teil ihres Stuhls',
    'Legen Sie die Hände auf die Schultern. Beschreiben Sie mit den Ellenbogen große Kreise vorwärts und rückwärts',
    'Mobilisation des Schultergürtels',
    NULL,
    'Schulter', 'Mobilisation', TRUE, FALSE, TRUE, FALSE),

-- Additional Back Exercises
(521, '60sXD_emL3I', 'Rücken Mobilisation Rotation - sitzend',
    'Setzen Sie sich aufrecht auf den vorderen Teil Ihres Stuhls',
    'Legen Sie den linken Handrücken auf Ihr rechtes Knie. Drehen Sie behutsam den Körper nach rechts. Anschließend wechseln Sie die Seite',
    'Mobilisation der Wirbelsäule',
    'Achten Sie auf eine gleichmäßige Atmung',
    'Rücken', 'Mobilisation', TRUE, FALSE, TRUE, TRUE),

(523, 'kbIOYY1v7Qw', 'Rücken Mobilisation Flexion - sitzend',
    'Setzen Sie sich aufrecht auf den vorderen Teil Ihres Stuhls',
    'Führen Sie den Oberkörper langsam nach vorne. Lassen Sie Kopf und Schultern locker nach unten hängen',
    'Mobilisation der Wirbelsäule',
    'Achten Sie auf eine gleichmäßige Atmung',
    'Rücken', 'Mobilisation', TRUE, FALSE, TRUE, FALSE),

-- Additional Belly Exercises
(102, 'yvIecluSuDA', 'Kräftigung der Bauchmuskulatur - sitzend',
    'Setzen Sie sich aufrecht auf den vorderen Teil Ihres Stuhls',
    'Legen Sie eine Hand aufs Knie.Heben Sie das Bein und drücken Sie Hand und Knie gegeneinander, der Oberkörper bleibt aufrecht',
    'Kräftigung der Bauchmuskulatur',
    'Atmen Sie ruhig weiter',
    'Bauch', 'Kraft', TRUE, FALSE, FALSE, TRUE),

-- Additional Chest Exercises
(204, '9Y4uZM1XNOE', 'Kräftigung der Brustmuskulatur - stehend',
    'Führen Sie das Theraband mittig um Ihren Rücken und greifen beide Seiten. Ellenbogen gebeugt',
    'Führen Sie die Bandenden vor dem Körper zusammen, strecken Sie dazu die Arme',
    'Kräftigung des Brustmuskels',
    'Durch die Grundspannung des Therabandes in der Ausgansposition können Sie die Schwierigkeit variieren. Atmen Sie ruhig weiter und halten Sie die Oberkörperspannung',
    'Brust', 'Kraft', FALSE, TRUE, TRUE, FALSE),

-- Additional Neck Exercises
(408, 'YAelLSfG6fA', 'Mobilisation der HWS Seitneigung - sitzend',
    'Setzen Sie sich aufrecht auf den vorderen Teil Ihres Stuhls',
    'Neigen Sie den Kopf im Wechsel zur rechten und zur linken Schulter',
    'Mobilisation des Nackens',
    'Bewegung langsam ausführen. Ruhig weiteratmen',
    'Nacken', 'Mobilisation', TRUE, FALSE, TRUE, FALSE),

-- Additional Butt Exercises
(301, 'CJbsxMR0u0I', 'Kräftigung der Gesäßmuskulatur - stehend',
    'Legen Sie die Mitte des Therabandes um das Fußgelenk und fixieren Sie mit dem anderen Fuß das Theraband',
    'Das Knie 90° anwinkeln und die Hacke langsam zum Gesäß führen. Spannung kurz halten und langsam in die Ausgangsposition zurückkehren',
    'Kräftigung der Gesäßmuskulatur und der Oberschenkelrückseite',
    'Beine gestreckt lassen, nicht nach vorne lehnen. Durch die Grundspannung des Therabandes in der Ausgansposition können Sie die Schwierigkeit variieren. Atmen Sie ruhig weiter und halten Sie die Oberkörperspannung',
    'Po', 'Kraft', FALSE, TRUE, TRUE, TRUE);
